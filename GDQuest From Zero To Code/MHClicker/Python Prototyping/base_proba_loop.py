from random import *
from termcolor import colored

"""
Lexicon :

variation               variation of the values that will make a success or a failure. 
also varia              the scale is rand = randrange(1, varia + 1)

critical_threshold      starting from the maximum value of the varia, on how many value do you have a critical success
success_threshold       starting from the maximum value of the varia, on how many value do you have a standard success
opportunity_threshold   from the success_threshold, how many values allow for a "better than nothing" partial success

critical success        do the intended thing but better (get 2 stacks of "effort value" instead of one, ICRPG style)
standard success        do the intended thing + secondary things if the tool has a secondary and isActiveOnSuccess 
partial success         if the tool has secondary properties (like a poison dagger), apply the secondary property

fail, opp, yay, crit    the four possibles resolutions (failure, opportunity, success, critical)
score threshold         yay on X or more, crit on Y or more
score sheet             4 * fail + 3 * opp + 2 * yay + 2 * crit 
"""


def get_all_resolution_parameters(variation, critical, success, opportunity, print_state=0) -> [dict[str, int], dict[str, str]]:
    """
    Convert player stat in resolution stat (varia 12, crit 2 => crit from 11 to 12)
    :param print_state: What it should print
    0 = everything
    1 = just the end result
    2 = just the board
    :param variation:
    :param critical:
    :param success:
    :param opportunity:
    :return: score thresholds (crit on 11+) and score sheet (4 fail, 4 opp, 3 yay, 2 crit)
    """

    success_threshold = variation - success + 1

    score_thresholds = {
        "opportunity": success_threshold - opportunity,
        "success": success_threshold,
        "critical": variation - critical + 1,
        "varia": variation,
    }

    f = "failure"
    o = "opportunity"
    s = "success"
    c = "critical"

    score_sheet = {
        f: 0,
        o: 0,
        s: 0,
        c: 0,
    }

    if print_state in [0]:
        print()
        print("Current stats")
    for value in range(1, variation + 1):
        ending = f
        if value >= score_thresholds["opportunity"]:
            ending = o
        if value >= score_thresholds["success"]:
            ending = s
        if value >= score_thresholds["critical"]:
            ending = c

        if print_state:
            print(f"{value:2} == {ending}")
        score_sheet[ending] += 1

    if print_state:
        print(f"Score sheet : {score_sheet}")

    return score_thresholds, score_sheet


def get_resolution(score_th, counts=None, print_param=0):
    """
    Pass scores, get a resolution depending on rand and scores
    :param score_th:
    :param counts:
    :return:
    """
    if counts is None:
        counts = {
            "critical": 0,
            "success": 0,
            "opportunity": 0,
            "failure": 0,
        }

    rand = randrange(1, score_th["varia"] + 1)

    is_critical = rand > score_th["critical"]
    is_success = rand > score_th["success"]
    is_opportunity = rand > score_th["opportunity"]

    if is_critical:
        result = "critical"
        counts["critical"] += 1
    elif is_success:
        result = "success"
        counts["success"] += 1
    elif is_opportunity:
        result = "opportunity"
        counts["opportunity"] += 1
    else:
        result = "failure"
        counts["failure"] += 1

    if print_param in [0]:
        print(f"{rand:2} == {result}")
    return rand, result


def tests_get_resolution(test_table, th):
    """
    Testing function, you pass [0, 0, 1] and it does the 3rd test but not the 1rst and 2nd
    :param test_table:      0 and 1 values to say what to do
    :param th:              Params for the function you wanna test
    :return:                Mékouï Mickey
    """

    counts = {
        "critical": 0,
        "success": 0,
        "opportunity": 0,
        "failure": 0,
    }

    for index, element in enumerate(test_table):
        if not element: continue

        print()
        print(f"=======   Test get_resol {index}   =======")
        if index == 0:
            get_resolution(th, counts)
        if index == 1:
            for x in range(0, 12):
                get_resolution(th, counts)
        if index == 2:
            reso_stats_test2, useless_sheet = get_all_resolution_parameters(20, 4, 8, 4)
            for x in range(0, 24):
                get_resolution(reso_stats_test2, counts)

        print()
        print(counts)
        counts = {x: 0 for x in counts}  # reset all values to 0


def get_score_sheet(score_sheet):

    class BasicColors:
        grey = "grey"
        red = "red"
        green = "green"
        yellow = "yellow"
        blue = "blue"
        magenta = "magenta"
        cyan = "cyan"
        white = "white"

    visualisation = ""
    i = 1
    for index, element in enumerate(score_sheet.values()):
        for x in range(0, int(element)):
            if index == 0:
                visualisation += colored(str(i), BasicColors.white)
            if index == 1:
                visualisation += colored(str(i), BasicColors.yellow)
            if index == 2:
                visualisation += colored(str(i), BasicColors.green)
            if index == 3:
                visualisation += colored(str(i), BasicColors.cyan)
            visualisation += " "
            i += 1
    print(visualisation)


def tests_get_score_sheet(test_table, sh):
    """
    Testing function, you pass [0, 0, 1] and it does the 3rd test but not the 1rst and 2nd
    :param test_table:      0 and 1 values to say what to do
    :param sh:              Params for the function you wanna test
    :return:                Mékouï Mickey
    """

    for index, element in enumerate(test_table):
        if not element: continue

        print()
        print(f"=======   Test get_score_sheet {index}   =======")

        # generate random varia, crit, yay, opp
        get_rand_val = lambda: [randrange(10, 21), randrange(0, 4), randrange(2, 6), randrange(0, 7)]

        if index == 0:
            get_score_sheet(sh)
        if index == 1:
            for x in range(0, 12):
                useless_th, reso_stats_test1 = get_all_resolution_parameters(*get_rand_val(), print_state=False)
                get_score_sheet(reso_stats_test1)
        if index == 2:
            for x in range(0, 24):
                useless_th, reso_stats_test2 = get_all_resolution_parameters(*get_rand_val(), print_state=True)
                get_score_sheet(reso_stats_test2)

        print()


if __name__ == '__main__':

    varia, crit, yay, opp = 12, 2, 4, 4
    thresholds, sheet = get_all_resolution_parameters(varia, crit, yay, opp)

    tests = [1, 1, 1]

    tests_get_resolution(tests, thresholds)

    tests = [1, 0, 0]

    tests_get_score_sheet(tests, sheet)
