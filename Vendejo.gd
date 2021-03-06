extends Node2D

onready var Tempo = get_node("Tempo")
onready var Nitrogeno_Nombroj = get_node("Nitrogeno/Nombroj")
onready var Bombo_Nombroj = get_node("Bombo/Nombroj")
onready var Bombo_Sono = get_node("Bombo/Sono")
onready var Nitrogeno_Sono = get_node("Nitrogeno/Sono")

var sumo = 0
var sekundo = 0
var minuto = 0

func _ready():
	Tutmonda.nitrogenoj = 0
	Tutmonda.bomboj = 0
	get_tree().set_auto_accept_quit(false)
	get_node("Enveno_sono").set("stream/play", Tutmonda.Agordejo.get_value("Agordoj", "Sonoj", true))
	for N in range(3):
		sumo += Tutmonda.Agordejo.get_value("Niveloj", "P"+str(Tutmonda.pako)+"N"+str(N),0)
	minuto = "%02d" % (sumo/60)
	sekundo = "%02d" % (sumo%60)
	Tempo.set_text(str(minuto)+":"+str(sekundo))

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().change_scene("res://Niveloj.tscn")

func _on_Nitrogeno_pressed():
	if sumo >= 10 and Tutmonda.nitrogenoj < 5:
		sumo -= 10
		minuto = "%02d" % (sumo/60)
		sekundo = "%02d" % (sumo%60)
		Tempo.set_text(str(minuto)+":"+str(sekundo))
		Tutmonda.nitrogenoj += 1
		Nitrogeno_Nombroj.set_text(str(Tutmonda.nitrogenoj)+"/5")
		Nitrogeno_Sono.set("stream/play", Tutmonda.Agordejo.get_value("Agordoj", "Sonoj", true))

func _on_Bombo_pressed():
	if sumo >= 5 and Tutmonda.bomboj < 10:
		sumo -= 5
		minuto = "%02d" % (sumo/60)
		sekundo = "%02d" % (sumo%60)
		Tempo.set_text(str(minuto)+":"+str(sekundo))
		Tutmonda.bomboj += 1
		Bombo_Nombroj.set_text(str(Tutmonda.bomboj)+"/10")
		Bombo_Sono.set("stream/play", Tutmonda.Agordejo.get_value("Agordoj", "Sonoj", true))

func _on_Komencu_pressed():
	get_tree().change_scene("res://Bazo.tscn")
