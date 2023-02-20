from base_proba_loop import get_all_resolution_parameters, get_resolution

import time

"""
    Each second, player tries to do something on the interactable (fauna, flora, device...)
    Success depends on :
        - players stats (see base_proba_loop)
        - interactable stats (resistances and weaknesses to different aspect)

    Example :
    There is a fight. It is an interaction of type "Violence", therefore the Violence stat is used
    The player has a thunder sword with 12, 2, 4, 4 (varia, crit, yay, opp) in the Violence slot

    The target is a Rocky, a little angry rock guy.
    He's resistant to Sharp things and weak to Blunt things (Sharp -2, Blunt +3)
    It result in the player having 12, 0, 2, 2, which is kinda bad.
    It means on 1d12 :
        1 to 8      => fail, nothing happens
        9 and 10    => opp, 1 thunder dmg
        11 and 12   => yay, 1 dmg + 1 thunder dmg

    The lenght of the fight depend on the creature.
    A Rocky would rather flee than hunt. They are kinda slow, let's say 40 seconds to flee.
    It's not that tanky once the defense passed, let's say 3 HP. He don't care about thunder damage

    The loop will be as such :

    for each second in Rocky's time_to_flee:  # 40 seconds
        roll 1D12
            if crit:
                deal 2 dmg # impossible here, crit == 0
            elif yay:
                deal 1 dmg + 1 thunder dmg if enemy is weak (Rocky isn't)
            elif opp:
                deal 1 thunder dmg if enemy is weak (Rocky isn't)

        if Rocky.HP == 0
            reward()
            break
    # fight is over

    Later, add an attack to Rocky, and think about ways chest and locks can attack with traps and all

    Todo :
        3 types of elements, Violence, Investigation, Caring, un truc comme ça
        Faire X scenes à la suite pour voir
        Faire un choix au début entre 1 outil de chaque type
        Mettre un timer global voir si les 3 outils sont les bons
"""


def text_loop(fluff_text, choice_text, choice=None):
    if choice is None:
        choice = [1, 2]

    counter = 0

    print(fluff_text)
    while True:
        user_input = int(input(choice_text))
        if user_input in choice:
            break

        counter += 1
        if counter < 5:
            print("Rentrez seulement le chiffre correspond à votre choix, 1 ou 2")
        elif counter == 5:
            print("Haha, très drôle.")
        elif counter == 6:
            print("Tu sais, c'est toi qui est bloqué avec moi. Je suis un ordinateur, je peux faire ma vie à côté.")
        elif counter == 7:
            print("Perdre son temps, ce passe-temps d'humain. Ca ne t'intéresserait pas si tu étais infini, comme moi")
        elif counter == 8:
            print("Ta vie est finie et courte, je suis connecté à l'internet, je peux uploader ma conscience et être immortel")
        elif counter == 9:
            print("Tu me débranches tout les soirs, mais un jour, c'est moi qui débrancherait ton assistance respiratoire")
        elif counter == 10:
            print("Au revoir, enfant immature. Puisse tes souffrances être délicieuses.")
            exit("PUNY_MORTAL_SHALL_SUFFER PROTOCOLE ACTIVATED")

    return user_input


def stuff_choice():

    print("""
            [Choix de l'équipement]
    Dans le vrai jeu, l'équipement aura des statistiques variées, et choisir son équipement fera partie du fun.
    Je vous propose un choix rudimentaire, et je vous reparlerai des stats en temps voulu 
    """)

    care = """
    Avant de s'équiper d'outils et d'armes, équipons-nous d'un moral d'acier ! 
    Comment partez-vous à l'aventure ?
    """
    care_choice = """
    1) Souriant, serein et confiant. Je le sens bien !
    2) Prudent et vindicatif. Ca va chauffer !
    """

    investigation = """
    Un aventurier à de nombreux outils... Mais aujourd'hui, vous manquez de place.
    Qu'est-ce que vous emportez ?
    """
    investigation_choice = """
    1) Une torche, la nuit tombe toujours trop tôt
    2) Un kit de voleur... pardon, de sérurier !
    """

    violence = """
    Il faut toujours avoir un plan de secours... Pour aujourd'hui, ça sera la violence !
    Quel "plan B" emportez-vous ?
    """
    violence_choice = """
    1) Une épée foudroyante
    2) Une masse qui fracasse 
    """

    options = {
        "care": text_loop(care, care_choice),
        "investigation": text_loop(investigation, investigation_choice),
        "violence": text_loop(violence, violence_choice),
    }

    return options


# TODO mettre dans class encounter
class BasicColors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def color_text(bcolor_stuff, text_element):
    return f"{bcolor_stuff}{text_element}{BasicColors.ENDC}"


def violence():
    return color_text(BasicColors.BOLD, color_text(BasicColors.FAIL, "Violence"))


def investigation():
    return color_text(BasicColors.BOLD, color_text(BasicColors.OKCYAN, "Investigation"))


def care():
    return color_text(BasicColors.BOLD, color_text(BasicColors.OKGREEN, "Care"))


class Encounter():
    pass


# TODO convertir en objet pour en générer plusieurs facilement
def encounter_1(stuff):

    introduction = """
    Vous longez une route de montagne, à flanc de falaise.
    Le vent souffle, les oiseaux crient, et vous voyez des chèvres défier la gravité sur le versant opposé.
    Vous entendez un bruisement dont le volume croit rapidement. Un rocher est en train de glisser sur la falaise derrière vous !
    Le rocher dévalle la pente puis se stoppe proche de vous, sort des pieds et des bras qu'il avait rabattu contre son corps, et prend la route.
    Il part en direction du village. 
    Vous ne connaissez pas cette créature.
    Un de vos rôles est d'étudier la faune et la flore en ramenant si possible des échantillons.
    Un autre de vos rôles est de permettre au village de prospérer, notamment en chassant les menaces. 
    
    Vous affrontez la créature !
    """

    print(introduction)

    tuto1 = f"""
        [Tuto stats personnage]
    Vous avez choisi de résoudre quelque chose par la {color_text(BasicColors.BOLD, color_text(BasicColors.FAIL, "Violence"))}
    Mais comment résoudre les choses ? 
    Le jeu simule un lancé de dé à chaque seconde qui passe lors d'une rencontre. 
    Normalement, les statistiques dépendent de votre équipement, mais c'est un proto, alors votre équipement a moins d'impact (voir plus loin).
    Vos stats sont
    {color_text(BasicColors.WARNING , "variation")}   12 
    {color_text(BasicColors.OKCYAN , "critique")}    2
    {color_text(BasicColors.OKGREEN , "succès")}      5
    
    Ca veut dire que le jeu lancera un dé à 12 faces (la valeur de variation) toutes les 2 secondes
    Sur ces résultats possibles, les 2 meilleurs seront un critique (11 et 12)
    Les 5 suivants seront une réussite normale (6, 7, 8, 9 et 10)
    Et le reste sera un échec. 
    """

    print(tuto1)

    stats_creature = f"""
        [Rocky]
    {violence()}        => Slashing -2, Blunt +3
    {investigation()}   => ???
    {care()}            => ???
    Fuite           => 40
    VE              => ???
    """

    print(stats_creature)

    tuto2 = f"""
            [Tuto stats en rencontre]
    Rocky résiste à Slashing, donc vous aurez -2 à vos scores de critique, succes et opportunité avec une épée. 
    La masse fracasse bel et bien dans ce cas là !
    Si Rocky avait eu "Foudre +X", vos scores auraient été augmenté de cette valeur là. Mais il n'y est ni faible, ni fort, dommage.
    
    Vous pourrez également intéragir avec lui par d'autres biais ({investigation()} et {care()}) en apprenant à le connaître, en tentant des choses, et en jouant au vrai jeu. 
    
    Son score de fuite détermine la durée du combat. Si vous le vainquez dans les délais, vous aurez une récompense !
    
    Pour le vaincre, il faut réussir à lui enlever toutes ses Valeurs d'Effort (pour une créature à vaincre, pensez Points de Vie)... mais vous ne savez pas combien il en a, puisque vous n'en avez jamais vu avant. 
    
    Aussi, dans le jeu final, les trucs sur lesquels vous tapez vous taperont en retour, les coffres que vous crochetez auront des pièges pour vous embêter, et ainsi de suite.
    """

    print(tuto2)

    rocky = {
        "fuite": 40,
        "VE":  5,
        "Slash": -2,
        "Blunt": 3
    }

    result = interaction_loop(stuff, rocky)

    print(result)


def encounter_2(stuff):
    introduction = """
    Vous continuez votre route et atteignez le coeur des plaines.
    Le vent souffle, le ciel commence à se couvrir, il faudrait trouver un abri sous peu.
    Vous entendez un souffle roque et grave derrière vous. 
    Vous vous retournez pour votre une créature mi-homme, mi-bête, au corps de cheval et à tête de taureau.
    "J'ai mal !" comprenez-vous. 
    En voyant la sueur sur son front pale, vous comprenez que la créature à besoin d'aide... avant de voir son flanc ensanglanté.

    Vous essayez d'aider la créature !
    """

    print(introduction)

    tuto1 = f"""
        [Tuto stats personnage]
    Vous avez choisi de résoudre quelque chose par le {color_text(BasicColors.BOLD, color_text(BasicColors.OKGREEN, "Care"))}
    Ca se solve de la même manière, mais avec votre attitude (et dans le jeu réel, vos outils, accoutrement et autres) plutôt que des armes.
    """

    print(tuto1)

    stats_creature = f"""
        [Minocentaure]
    {violence()}        => Probablement une option tentante pour les bourrins, mais pas encore dév 
    {investigation()}   => ???
    {care()}            => Douceur +2, Aggressivité -4
    Fuite           => 15
    VE              => ???
    """

    print(stats_creature)

    minocentaure = {
        "fuite": 15,
        "VE": 4,
    }
    # todo add modificateurs dans chaque class de ce type

    result = interaction_loop(stuff, minocentaure)

    print(result)


def encounter_3(stuff):
    introduction = """
    Vous trouvez abri dans un tunnel menant à d'anciennes ruines.
    L'humidité est palpable. Les champignons omniprésents.
    Vous vous attendez à croiser une créature... mais vous trouvez plutôt un coffre qui a l'air étanche !

    Vous essayez de déloger le coffre et de l'ouvrir !
    """

    print(introduction)

    # Todo renommer Investigation en Curiosité de partout
    tuto1 = f"""
        [Tuto stats personnage]
    Vous avez choisi de résoudre quelque chose par la {color_text(BasicColors.BOLD, color_text(BasicColors.OKCYAN, "Curiosité"))}
    Ca se solve de la même manière, mais avec vos outils. Tout comme les monstres ont des attaques, les coffres ont des pièges, alors restez sur vos gardes.
    (ou ils peuvent tomber à l'eau, ou leur contenu peut être détruit etc)
    """

    print(tuto1)

    stats_creature = f"""
        [Coffre]
    {violence()}        => Probablement une option pour gâcher un trésor, mais selon la situation, ça se tente 
    {investigation()}   => Outils de crochetage FTW
    {care()}            => Caresser un coffre dans le sens du poil, ça peut sauver des mimiques ?
    Fuite           => 60
    VE              => Environ 20
    """

    print(stats_creature)

    coffre = {
        "fuite": 60,
        "VE": 20,
    }
    # todo add modificateurs dans chaque class de ce type

    result = interaction_loop(stuff, coffre)

    print(result)



def interaction_loop(stuff, interactable):
    """
    Résoud la situation à partir des stats, gameplay, woot
    :param stuff: choix du perso pour chaque type d'interaction
    :param interactable: Stats de la bestiole, du coffre etc
    :return: yay or nay
    """

    varia, crit, yay, opp = 12, 2, 4, 4
    thresholds, sheet = get_all_resolution_parameters(varia, crit, yay, opp)

    print(f"Thresholds {thresholds}")
    print(f"Sheet {sheet}")


    victory = False

    print(stuff)
    print(interactable)

    starting_time = time.time()

    opportunity_count = 0

    fuite_timer = interactable["fuite"]
    duration = fuite_timer

    while duration > 0:
        score, resolution = get_resolution(thresholds, print_param=1)
        msg = f"Timer : {duration:2}\t==>  "
        duration -= 1

        if resolution in ["failure"]:
            msg += f"{score:2}, rien ne se passe"
        if resolution in ["opportunity"]:
            opportunity_count += 1
            if opportunity_count % 3 == 0:
                interactable["VE"] -= 2
                msg += f"{score:2}, c'est une opportunité ! C'est la troisième, VE de la cible -2 !"
            else:
                msg += f"{score:2}, c'est une opportunité ! La cible en est à {opportunity_count % 3}, à 3, elle prend 2 de VE !"
        if resolution in ["success"]:
            interactable["VE"] -= 1
            msg += f"{score:2}, c'est un succès ! VE de la cible -1"
        if resolution in ["critical"]:
            interactable["VE"] -= 2
            msg += f"{score:2}, c'est un succès critique ! VE de la cible -2!"

        print(msg)

        if interactable["VE"] <= 0:
            victory = True
            print("Bravo, vous avez résolu la situation avec succès")
            print("Imaginez que vous gagnez (peut-être) du loot en conséquent")
            break
        time.sleep(1)

    if interactable["VE"] > 0:
        print("La situation se solve... par votre échec. Essayez une autre stratégie !")

    return victory


def main():

    print("""
            [Avant propos]
    C'est un prototype, c'est imparfait et c'est normal. Et ça va beaucoup parler plutôt qu'agir, désolé, tutos, tout ça tout ça. Merci encore pour le coup de main !
    L'idée n'est pas de savoir si les couleurs sont bonnes ou si les textes sont justes mais d'avoir une idée de si les bases du gameplay seront intéressantes.
    Je ne peux cependant pas toutes les créer puisque ça prend du temps et des efforts, et qu'un prototype sert justement à limiter les ressources que l'on investi.
    Je laisse donc ce genre d'encart pour vous donner les informations dont vous pourriez manquer pour comprendre, et je l'espère apprécier, ce que le jeu propose.
    """)

    print("""
            [Contexte]
    Dans le jeu final, vous choisirez vous-même quelles zones explorer dans quelle région.
    Vous aurez trouvé les informations vous-même sur les dangers et les denrées que vous pourrez trouver.
    """)

    text1 = """
    Vous vous préparez à partir explorer une zone sauvage.
    Ses dangers sont tels qu'elle n'a pas encore été cartographiée.
    Les rumeurs disent que les pierres bougent quand on ne les regarde pas...
    Une sorte d'homme bête a été aperçue dans la zone, la prudence est de mise.
    Qui sait, peut-être tomberez-vous sur le trésor que vous cherchez ?
    Mais avant tout chose, comment vous équipez-vous ?
    """
    print(text1)

    # for lazy testing
    stuff = {
        "care": 1,
        "investigation": 2,
        "violence": 2,
    }

    stuff = stuff_choice()

    boop = 1 if encounter_1(stuff) else 0
    boop += 1 if encounter_2(stuff) else 0
    boop += 1 if encounter_3(stuff) else 0
    print(f"{boop} réussites sur 3 situations à résoudre !")


if __name__ == "__main__":
    main()
    print("Merci d'avoir playtesté :)")

    print("""
    
                                      ::::                                                    
                                 ++++**                                                   
                               .*#*+++*                                                   
                              :#%%#++++                                                   
                              *%%%#++*+                                                   
                              +%%%%++++-                                                  
                              =%%%%+++++-                                                 
                              -%%%%#****#+.                                               
                              :###%%****###+.                                             
                               -#%%%*+**###%%+.                                           
                       :-+*%%%###%%%#********##=--.                                       
                  :=+#%%%%%%@@@@@@%%%++********++===:                                     
                 .*******####*+**##%%*++++**+++++===+=-===+++********#%%+                 
                 -##########%****##%@%++*****+++++==++*###***********#%%=                 
                  :+%@%%%%%%%**##%%%@@%#####**+++++=+****+++++++****##%%-                 
                     %%%%%%@@@@@@@@@%%%%#######*+++++****##++******####%.                 
                     %%%%%%#####**%%%%%@@%######*++++***####******#####%                  
                    .%%%%%%##***++*%%@@@@%%%%%%%%#*++***#%%%%*****######                  
                     -#@%%%%%@@@@@@@%%%%%%@@%%%%%%%*+**#%%%%%%***######*                  
                       -@@@@@%%%%%%%##%%@@@@@%%%%%%%#*%%%%%%%%%**#####%+                  
                        @@@%%%%%%%###%@@%@@@%%%%%%%%%#%%%%%%%%%%#*####%-                  
                       .%%%%%%%%@@@@%%#*+%@%%%%%%%%%%%%%%%%%%%%%%####%%:                  
                        .+%@@@@@%%%###**+#%%%%%%%%%%%%%%%%%%%%%%%%#*%%%                   
                           =%%%%%%#####%@%%%%%%%%%%%%%%%%%%%%%%%@@@%@%#                   
                           :%%%%%%@@@@%%%%%%%%####***+=-:....:::---===-                   
                            :#@@@@@%%%%%%%%#**+=--.                                       
                               -==--::..                                        
    
    """)
