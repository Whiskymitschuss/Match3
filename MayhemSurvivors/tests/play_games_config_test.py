"""Configuration validation only: no real Google project, authentication or scores."""
import importlib.util,unittest
from pathlib import Path
spec=importlib.util.spec_from_file_location('rf_build_games',Path(__file__).resolve().parents[1]/'tools/build_play_games.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
class Config(unittest.TestCase):
 def example(self):return {'provider':'google_play','project_id':'1234567890','boards':{'campaign:scrapyard:normal':'CgkITestFixture'}}
 def test_valid_explicit_configuration(self):self.assertEqual(module.validate(self.example()),self.example())
 def test_no_default_or_zero_project(self):
  for value in ['', '0', 'abc', 1234, '12\n34']:
   data=self.example();data['project_id']=value
   with self.assertRaises(ValueError):module.validate(data)
 def test_wrong_categories_and_ids(self):
  for key,value in [('practice:scrapyard:normal','CgkITestFixture'),('campaign:missing:normal','CgkITestFixture'),('campaign:scrapyard:normal','https://other.example/')]:
   data=self.example();data['boards']={key:value}
   with self.assertRaises(ValueError):module.validate(data)
 def test_unique_categories(self):
  data=self.example();data['boards']['endless:scrapyard:normal']='CgkITestFixture'
  with self.assertRaises(ValueError):module.validate(data)
 def test_empty_and_unknown_provider(self):
  for data in [{},{'provider':'unknown','project_id':'1234','boards':{}},{'provider':'google_play','project_id':'1234','boards':{}}]:
   with self.assertRaises(ValueError):module.validate(data)
if __name__=='__main__':unittest.main(verbosity=2)
