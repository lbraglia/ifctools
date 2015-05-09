context("wrong_fc tests")

test_that("Regular fiscal codes", {
            expect_true(wrong_fc("qWeASd34D12h 221M   "))
            expect_false(wrong_fc("QWEASD34D12H221M"))
          })

test_that("Temporary fiscal codes", {
            expect_true(wrong_fc(" 12312312312 "))
            expect_false(wrong_fc("12312312312"))
          })
