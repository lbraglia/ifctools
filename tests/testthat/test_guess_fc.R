context("guess_fc tests")

test_that("Regular fiscal codes", {
            ## using fictious data
            expect_identical(guess_fc("Rossi",
                                      "Mario",
                                      as.Date("1960-01-01"),
                                      "F205",
                                      FALSE),
                             "RSSMRA60A01F205T")
            expect_identical(guess_fc("Bianchi",
                                      "Giovanna",
                                      as.Date("1970-01-01"),
                                      "H501",
                                      TRUE),
                             "BNCGNN70A41H501V")
          })

