local utils = require("user.utils")

describe("user.utils", function()
    it("get last element in list", function()
        -- Given
        local test_list = {
            "a",
            "b",
            "c",
            "d",
            "e",
            "f",
        }

        -- When
        local actual = utils.last(test_list)

        -- Then
        assert.are.same("f", actual)
    end)
end)
