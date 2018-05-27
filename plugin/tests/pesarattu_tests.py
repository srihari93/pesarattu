import unittest
import pesarattu as sut


@unittest.skip("Don't forget to test!")
class PesarattuTests(unittest.TestCase):

    def test_example_fail(self):
        result = sut.pesarattu_example()
        self.assertEqual("Happy Hacking", result)
