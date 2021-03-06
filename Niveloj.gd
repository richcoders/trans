extends Control

onready var Niveloj = get_node("Niveloj")
onready var Konservu = get_node("Konservu")
onready var Kasxi = get_node("Konservu/Kasxi")

var sumo = 0
const tempoj = [
		[0,0,0,0],
		[0,0,0,0],
		[0,0,0,0],
		[0,0,0,0]
	]

var pakoj = []

func _init():
	var lingvo = Tutmonda.Agordejo.get_value("Lingvo", "lingvo")
	if TranslationServer.get_locale() != lingvo:
		TranslationServer.set_locale(lingvo)

func _ready():
	if not (Tutmonda.rekordita or Tutmonda.jxus_pasita):
		get_node("Enveno_sono").set("stream/play", Tutmonda.Agordejo.get_value("Agordoj", "Sonoj", true))
	get_node("Fonmuziko").set("stream/play", Tutmonda.Agordejo.get_value("Agordoj", "Muzikoj", true))
	pakoj = [
			[tr("Enkonduko"), tr("Turneto"), tr("La Parko"), tr("Estreto")],
			[tr("Enirejo"), tr("Gvardioj"), tr("La Produktejo"), tr("Estroj")],
			[],
			[tr("Longa Koridoro"), tr("La Halo"), tr("Labirinto"), tr("Estrego")]
		]
	get_tree().set_auto_accept_quit(true)
	get_node("Pakoj").set_selected(Tutmonda.pako)
	var Nivelo = null
	for N in range(4):
		Nivelo = Niveloj.get_node("N"+str(N))
		if Tutmonda.rekordita and N == Tutmonda.nivelo:
			Tutmonda.rekordita = false
			var Novrekordo = get_node("Novrekordo")
			var Novrekordo_Aperi = Novrekordo.get_node("Aperi")
			Novrekordo.set_global_pos(Nivelo.get_global_pos()+Vector2(660,60))
			Novrekordo_Aperi.interpolate_property(Novrekordo, "transform/scale",
			Vector2(5,5), Vector2(0.7,0.7),
			0.75, Tween.TRANS_QUINT, Tween.EASE_IN
			)
			Novrekordo_Aperi.start()
			Novrekordo.show()
			Novrekordo.get_node("Sono").set("stream/play", Tutmonda.Agordejo.get_value("Agordoj", "Sonoj", true))
		Nivelo.set_text(pakoj[Tutmonda.pako][N])
		if N != 3:
			Nivelo.get_node("Tempo").set_text(
				str(Tutmonda.Agordejo.get_value("Niveloj", "P"+str(Tutmonda.pako)+"N"+str(N), 0))+"s"
			)
			sumo += Tutmonda.Agordejo.get_value("Niveloj",
			 		"P"+str(Tutmonda.pako)+"N"+str(N), 0)
		else:
			if Tutmonda.Agordejo.get_value("Niveloj", "P"+str(Tutmonda.pako)+"N"+str(N)):
				var Pasita = get_node("Pasita")
				var Pasita_Aperi = get_node("Pasita/Aperi")
				Pasita.show()
				if Tutmonda.jxus_pasita:
					Tutmonda.jxus_pasita = false
					Pasita_Aperi.interpolate_property(Pasita, "transform/scale",
					Vector2(5,5), Vector2(0.7,0.7),
					0.75, Tween.TRANS_QUINT, Tween.EASE_IN
					)
					Pasita_Aperi.start()
					get_node("Novrekordo/Sono").set("stream/play", Tutmonda.Agordejo.get_value("Agordoj", "Sonoj", true))
		Nivelo.connect("pressed", self, "_on_Nivelo_pressed", [Nivelo])
	get_node("Sumo").set_text(str(sumo))
	Kasxi.interpolate_property(Konservu, "visibility/opacity", 1,0,
		2, Tween.TRANS_QUINT, Tween.EASE_IN
	)

func _on_Lingvo_pressed():
	get_tree().change_scene("res://Lingvo.tscn")

func _on_Pri_pressed():
	get_tree().change_scene("res://Pri.tscn")

func _on_Nivelo_pressed(Nivelo):
	var N = int(Nivelo.get_name().substr(1,3))
	var bezonita_tempo = tempoj[Tutmonda.pako][N]
	if sumo >= bezonita_tempo:
		Tutmonda.nivelo = N
		Tutmonda.rekordita = false
		if N == 3:
			get_tree().change_scene("res://Vendejo.tscn")
		else:
			get_tree().change_scene("res://Bazo.tscn")
	else:
		Konservu.get_node("Mesagxo").set_text(tr("Pliu vian konservitan tempon al")+" "+str(bezonita_tempo)+"s")
		Kasxi.resume_all()

func _on_Kasxi_tween_complete( object, key ):
	Kasxi.stop_all()

func _on_Pakoj_button_selected( idx ):
	Tutmonda.pako = idx
	get_tree().reload_current_scene()

func _on_Agordoj_pressed():
	get_tree().change_scene("res://Agordoj.tscn")