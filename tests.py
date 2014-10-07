from __future__ import print_function
import unittest
import datetime
import requests

class DashboardTests(unittest.TestCase):

    def testRegeneratedLastNight(self):
        response = requests.get('http://dashboard.iatistandard.org/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(str(datetime.date.today()), response.text)

def main():
    unittest.main()

if __name__ == '__main__':
    main()
