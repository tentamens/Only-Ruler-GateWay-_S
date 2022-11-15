extends Node


var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1910
var max_players = 4000

func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();


func _ready():
	StartServer()

func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("Gateway server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
	
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " Connected")

func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")


remote func LoginRequest(username, password):
	print("Login request received")
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.AuthenticatePlayer(username, password, player_id)

remote func CreateAccountRequest(username, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	var valid_request = true
	if username == "":
		print("username")
		valid_request = false
	if password == "":
		print("password")
		valid_request = false
	if password.length() <= 6:
		print("length")
		valid_request = false
	
	if valid_request == false:
		print("false")
		ReturnCreateAccountRequest(valid_request, player_id, 1)
	else:
		Authenticate.CreateAccount(username.to_lower(), password, player_id)


func ReturnCreateAccountRequest(result, player_id, message):
	print("sending back to client")
	rpc_id(player_id, "ReturnCreateAccountRequest", result, message)
	# 1 means failed to create 2 means its already a username 3 is success
	network.disconnect_peer(player_id)



func ReturnLoginRequest(result, player_id, token):
	rpc_id(player_id, "ReturnLoginRequest", result, token)
	network.disconnect_peer(player_id)

