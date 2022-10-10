export default defineCommand(({ name, template, schema }) => {
	name('helloworld')
	schema({
		arguments: [
			{ type: 'string', additionalData: { values: ['1', '2', '3'] } },
		],
	})

	template((names) => {
		return names.map((name) => `say Hello ${name}`)
	})
})