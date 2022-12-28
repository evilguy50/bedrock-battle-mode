export default defineCommand(({ name, template, schema }) => {
	name("playermsg")
	schema({
		arguments: [
			{ type: "selector" },
			{ type: "string" }
		],
	})

	template(([selector, phrase]) => {
		return `tellraw @a {"rawtext": [{"text": "<"},{"selector": "${selector}"},{"text": "> ${phrase}"}]}`
	})
})
