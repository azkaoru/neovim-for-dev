local M = {}

function M.setup()
	require("CopilotChat").setup({
		show_help = "yes",
		prompts = {
			Explain = {
				prompt = "/COPILOT_EXPLAIN コードを日本語で説明してください",
				mapping = '<leader>cce',
				description = "コードの説明をお願いする",
			},
			Review = {
				prompt = '/COPILOT_REVIEW コードを日本語でレビューしてください。',
				mapping = '<leader>ccr',
				description = "コードのレビューをお願いする",
			},
			Fix = {
				prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
				mapping = '<leader>ccf',
				description = "コードの修正をお願いする",
			},
			Optimize = {
				prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
				mapping = '<leader>cco',
				description = "コードの最適化をお願いする",
			},
			Docs = {
				prompt = "/COPILOT_GENERATE 選択したコードに関するドキュメントコメントを日本語で生成してください。",
				mapping = '<leader>ccd',
				description = "コードのドキュメント作成をお願いする",
			},
			Tests = {
				prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
				mapping = '<leader>cct',
				description = "テストコード作成をお願いする",
			},
			FixDiagnostic = {
				prompt = 'コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。',
				mapping = '<leader>ccdm',
				description = "コードの修正をお願いする",
				selection = require('CopilotChat.select').diagnostics,
			},
			Commit = {
				prompt =
				'実装差分に対するコミットメッセージを日本語で記述してください。',
				mapping = '<leader>ccmc',
				description = "コミットメッセージの作成をお願いする",
				selection = require('CopilotChat.select').gitdiff,
			},
			CommitStaged = {
				prompt =
				'ステージ済みの変更に対するコミットメッセージを日本語で記述してください。',
				mapping = '<leader>ccms',
				description = "ステージ済みのコミットメッセージの作成をお願いする",
				selection = function(source)
					return require('CopilotChat.select').gitdiff(source, true)
				end,
			},
		},
		mappings = {
    -- Use tab for completion
    complete = {
        insert = "", -- Explicitly set an empty string. It lets regular copilot plugin overrides CopilotChat.nvim
    }
}
	})
end

return M
