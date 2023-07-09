import unittest

class NumbersTest(unittest.TestCase):

    def test_equal(self):
        self.assertEqual(1 + 1, 3)

if __name__ == '__main__':
    unittest.main()
