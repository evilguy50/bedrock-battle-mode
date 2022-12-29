export default defineCommand(({ name, template, schema }) => {
	name("setting")
	schema({
		arguments: [
			{ type: "string" },
			{ type: "number" }
		],
	})

	template(([setting, value]) => {
		return `scoreboard players set ${setting} settings ${value}`;
	})
})
