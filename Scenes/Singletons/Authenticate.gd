extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1981
var ip = "127.0.0.1"

func _ready():
	StartServer()




func StartServer():
	print("Starting server")
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnection_failed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")


func _OnConnectionSucceeded():
	print("Succesfully to connect to authentication server")

func _OnConnection_failed():
	print("Failed to connect to authentication server")



func AuthenticatePlayer(username, password, player_id):
	print("sending out authenication request")
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)


remote func AuthenticationResults(result, player_id, token):
	print("result received and replying to player login request")
	Gateway.ReturnLoginRequest(result, player_id, token)

func CreateAccount(username, password, player_id):
	print("sending out create account request")
	rpc_id(1, "CreateAccount", username, password, player_id)



remote func CreateAccountResults(result, player_id, message):
	print("results received and replying to the player create account request")
	Gateway.ReturnCreateAccountRequest(result, player_id, message)




