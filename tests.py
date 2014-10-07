from __future__ import print_function
import unittest
import datetime
import requests

class DashboardTests(unittest.TestCase):

    def testRegeneratedLastNight(self):
        """
        Test that the dashboard was successfully regenrated last night by
        looking for today's date in the text of the website.

        This test assumes that these tests are being run substantially later in
        the day than the early morning dashboard run (e.g. as of writing these
        tests are scheduled for noon).
        It would be better to check the time of day, set a time we expect
        dashboard generation to have finished, and to use yesterday's date
        before this time.

        """

        response = requests.get('http://dashboard.iatistandard.org/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(str(datetime.date.today()), response.text)

def main():
    unittest.main()

if __name__ == '__main__':
    main()
