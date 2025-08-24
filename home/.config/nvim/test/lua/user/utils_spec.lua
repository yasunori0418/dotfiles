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
    describe("autocmd utils", function()
        local test_augroup
        before_each(function()
            test_augroup = vim.api.nvim_create_augroup("test_augroup", { clear = true })
        end)
        after_each(function()
            vim.iter(vim.api.nvim_get_autocmds({ group = test_augroup }))
                :map(function(v)
                    return v.id
                end)
                :each(function(id)
                    vim.api.nvim_del_autocmd(id)
                end)
        end)
        it("autocmd_set", function()
            -- Given
            local test_func = function()
                vim.print("test autocmd_set")
            end

            -- When
            utils.autocmd_set("BufReadPost", "*", test_func, test_augroup)

            -- Then
            local actual = vim.api.nvim_get_autocmds({ group = test_augroup })
            assert.are.same(1, #actual)
            assert.are.same("*", actual[1].pattern)
            assert.are.same("BufReadPost", actual[1].event)
            assert.are.same(test_func, actual[1].callback)
        end)
    end)
end)
