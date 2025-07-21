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

    describe("ifx", function()
        it("true", function()
            -- When
            local actual = utils.ifx(true, "right", "left")

            -- Then
            assert.are.same("right", actual)
        end)
        it("false", function()
            -- When
            local actual = utils.ifx(false, "right", "left")

            -- Then
            assert.are.same("left", actual)
        end)
    end)
end)
