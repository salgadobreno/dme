//This server is meant to replace the `yarn api`("json-server --watch db.json --port 8080 --id serial_number") since running it this way let us do more customizations so the React Dev keeps up with the sinatra environment i.e.: This change was made so that we could envelope the responses inside the 'data' key
//TODO: maybe we could add code from the json-server repo so that it accepts parameterized options?
const jsonServer = require('json-server')
const server = jsonServer.create()
const router = jsonServer.router('db.json')
const middlewares = jsonServer.defaults()

router.db._.id = "serial_number"

router.render = (req,res) => {
  //TODO: add way to override the 'metadata' with query params('?success=false')
  res.jsonp({
    data: res.locals.data,
    success: true
  })
}

server.use(middlewares)
server.use(router)
server.listen(8080, () => {
  console.log('JSON Server is running')
})

