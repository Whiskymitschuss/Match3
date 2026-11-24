package com.rfworlds.mayhemsurvivors.playgames;

import android.app.Activity;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.games.PlayGamesSdk;
import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;
import org.godotengine.godot.plugin.UsedByGodot;
import org.json.JSONObject;
import java.util.Collections;
import java.util.Set;

/** RF Worlds: optional leaderboard bridge. No cloud saves or startup sign-in. */
public final class RFPlayGames extends GodotPlugin {
    private boolean initialized;
    private volatile boolean alive = true;
    public RFPlayGames(Godot godot) { super(godot); }
    @Override public String getPluginName() { return "RFPlayGames"; }
    @Override public Set<SignalInfo> getPluginSignals() {
        return Collections.singleton(new SignalInfo("event", String.class, String.class));
    }
    private void event(String kind, String token, String player, String name) {
        if (!alive) return;
        try {
            JSONObject value = new JSONObject();
            value.put("token", token);
            if (player != null) value.put("player", player);
            if (name != null) value.put("name", name);
            final String json = value.toString();
            runOnRenderThread(() -> { if (alive) emitSignal("event", kind, json); });
        } catch (Exception ignored) { /* Strings only; no executable data. */ }
    }
    private void failure(String token) { event("unavailable", token, null, null); }
    private Activity initialize(String token) {
        Activity activity = getActivity();
        if (!alive || activity == null || activity.isFinishing()) { failure(token); return null; }
        if (GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(activity) != ConnectionResult.SUCCESS) {
            failure(token); return null;
        }
        if (!initialized) { PlayGamesSdk.initialize(activity); initialized = true; }
        return activity;
    }
    private void identity(Activity activity, String token) {
        PlayGames.getPlayersClient(activity).getCurrentPlayer()
            .addOnSuccessListener(player -> event("authenticated", token, player.getPlayerId(), player.getDisplayName()))
            .addOnFailureListener(error -> failure(token));
    }
    @UsedByGodot public void authenticate(boolean interactive, String token) {
        runOnUiThread(() -> {
            try {
                Activity activity = initialize(token); if (activity == null) return;
                PlayGames.getGamesSignInClient(activity).isAuthenticated()
                    .addOnSuccessListener(result -> {
                        if (result.isAuthenticated()) { identity(activity, token); return; }
                        if (!interactive) { failure(token); return; }
                        PlayGames.getGamesSignInClient(activity).signIn()
                            .addOnSuccessListener(auth -> {
                                if (auth.isAuthenticated()) identity(activity, token); else failure(token);
                            }).addOnFailureListener(error -> failure(token));
                    }).addOnFailureListener(error -> failure(token));
            } catch (Exception error) { failure(token); }
        });
    }
    @UsedByGodot public void submit_score(String board, long score, String run, String expectedPlayer, String token) {
        runOnUiThread(() -> {
            try {
                Activity activity = initialize(token); if (activity == null) return;
                if (!board.startsWith("Cgk") || score < 1 || score > 7200000L || !run.matches("[0-9a-f]{32}")) {
                    failure(token); return;
                }
                PlayGames.getPlayersClient(activity).getCurrentPlayer()
                    .addOnSuccessListener(player -> {
                        if (!expectedPlayer.equals(player.getPlayerId())) { failure(token); return; }
                        PlayGames.getLeaderboardsClient(activity).submitScoreImmediate(board, score, run)
                            .addOnSuccessListener(result -> event("score_saved", token, null, null))
                            .addOnFailureListener(error -> failure(token));
                    })
                    .addOnFailureListener(error -> failure(token));
            } catch (Exception error) { failure(token); }
        });
    }
    @UsedByGodot public void show_board(String board, String expectedPlayer, String token) {
        runOnUiThread(() -> {
            try {
                Activity activity = initialize(token); if (activity == null) return;
                PlayGames.getPlayersClient(activity).getCurrentPlayer()
                    .addOnSuccessListener(player -> {
                        if (!expectedPlayer.equals(player.getPlayerId())) { failure(token); return; }
                        PlayGames.getLeaderboardsClient(activity).getLeaderboardIntent(board)
                            .addOnSuccessListener(intent -> {
                                if (!alive || activity.isFinishing()) return;
                                activity.startActivityForResult(intent, 7023);
                                event("dialog_opened", token, null, null);
                            }).addOnFailureListener(error -> failure(token));
                    }).addOnFailureListener(error -> failure(token));
            } catch (Exception error) { failure(token); }
        });
    }
    @Override public void onMainDestroy() { alive = false; super.onMainDestroy(); }
}
