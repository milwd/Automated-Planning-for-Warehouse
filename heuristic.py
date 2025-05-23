
import matplotlib.pyplot as plt


def create_state(pm1, pm2, pc1, pc2, fm1, fm2, fl1, fl2, wc1, wc2, lc1, lc2, mv1, mv2, atcc1, atcc2):
    state = {
        'mover1' : [pm1, fm1, mv1],
        'mover2' : [pm2, fm2, mv2],
        'crate1' : [pc1, wc1, lc1, atcc1],
        'crate2' : [pc2, wc2, lc2, atcc2],
        'loader1' : [fl1],
        'loader2' : [fl2]
    }
    return state

def calc_state0(state, weird=True):
    crates = ['crate1', 'crate2']
    loaders = ['loader1', 'loader2']
    movers = ['mover1', 'mover2']

    h = 30 * sum([int (not (state[x][2])) for x in crates]) + \
        0.1 * sum([int (not (state[x][2])) * int (not (weird)) for x in movers]) + \
        1 * sum([int(state[x][0]) * int(not bool(state[x][1])) for x in movers])
    p = 0
    for crate in crates:
        for mover in movers:
            p += abs(state[crate][0] - state[mover][0]) * state[crate][3]
    h += 0.5 * p

    return h

def calc_state2(state):
    crates = ['crate1', 'crate2']
    movers = ['mover1', 'mover2']
    h = (
        sum([state[crate][0] + 200 * state[crate][3] for crate in crates]) + 
        sum([50 * (1 - state[crate][2]) * state[crate][3] for crate in crates]) + 
        sum([0.5 * state[mover][0] * state[mover][1] for mover in movers]) + 
        sum([
            0.2 * min(abs(state[crate][0] - state[mover][0]) for mover in movers if state[mover][1])
            if any(state[m][1] for m in movers) else 0.0 # If no movers are free, this term is 0
            for crate in crates if state[crate][3] and not state[crate][2]
        ])
    )
    return h

posm1 = [x for x in range(0, 10)] + [x for x in range(10, 0, -1)] + [x for x in range(0, 20)] + [x for x in range(20, 0, -1)]
posm2 = [x for x in range(0, 10)] + [x for x in range(10, 0, -1)] + [0] * 40
posc1 = [10] * 20 + [0] * 40
posc2 = [20] * 60 
frem1 = [1] * 10 + [0] * 10 + [1] * 20 + [0] * 20
frem2 = [1] * 10 + [0] * 10 + [1] * 40
weic1, weic2 = 70, 20
lodc1 = [0] * 20 + [1] * 40
lodc2 = [0] * 60
movm1 = [1] * 60
movm2 = [1] * 20 + [0] * 40
atcc1 = [1] * 10 + [0] * 50
atcc2 = [1] * 40 + [0] * 20

heuristics = []
for i in range(60):
    test = create_state(posm1[i], posm2[i], 
                        posc1[i], posc2[i], 
                        frem1[i], frem2[i], 
                        True, True, 
                        weic1, weic2, 
                        lodc1[i], lodc2[i], 
                        movm1[i], movm2[i], 
                        atcc1[i], atcc2[i])
    heuristics.append(0.5 * calc_state2(test) + 2 * calc_state0(test))

fig, axs = plt.subplots(6, 1, figsize=(12, 30))
fig.subplots_adjust(hspace=0.5)

axs[0].plot(posm1, marker='o', label='m1', linewidth=3)
axs[0].plot(posm2, marker='*', label='m2', linewidth=3)
axs[0].set_ylabel('Mover Pos', fontsize=12, fontweight='bold')
axs[1].plot(posc1, label='c1', linewidth=3)
axs[1].plot(posc2, label='c2', linewidth=3)
axs[1].axvspan(59, 60, color='green', alpha=0.3)
axs[1].set_ylabel('Crate Pos', fontsize=12, fontweight='bold')
axs[1].axvspan(39, 40, color='pink', alpha=0.6)
axs[1].axvspan(19, 20, color='green', alpha=0.3)
axs[2].plot(frem1, label='m1', linewidth=3)
axs[2].plot(frem2, label='m2', linewidth=3)
axs[2].set_ylabel('Free Mover', fontsize=12, fontweight='bold')
axs[2].axvspan(9, 10, color='pink', alpha=0.6)
axs[2].axvspan(39, 40, color='pink', alpha=0.6)
axs[2].axvspan(19, 20, color='green', alpha=0.3)
axs[2].axvspan(59, 60, color='green', alpha=0.3)
# axs[3].plot(lodc1, label='c1', linewidth=3)
# axs[3].plot(lodc2, label='c2', linewidth=3)
# axs[3].set_ylabel('Loaded', fontsize=12, fontweight='bold')
# axs[3].axvspan(19, 20, color='green', alpha=0.3)
axs[3].plot(movm1, label='m1', linewidth=3)
axs[3].plot(movm2, label='m2', linewidth=3)
axs[3].set_ylabel('Moving', fontsize=12, fontweight='bold')
axs[3].axvspan(19, 20, color='green', alpha=0.3)
axs[3].axvspan(59, 60, color='green', alpha=0.3)
axs[4].plot(atcc1, label='c1', linewidth=3)
axs[4].plot(atcc2, label='c2', linewidth=3)
axs[4].set_ylabel('At Company', fontsize=12, fontweight='bold')
axs[4].axvspan(9, 10, color='pink', alpha=0.6)
axs[4].axvspan(39, 40, color='pink', alpha=0.6)
axs[5].plot(heuristics, linewidth=3, color='black',)
axs[5].set_ylabel('Heuristic', fontsize=12, fontweight='bold')
axs[5].set_xlabel('States', fontsize=12, fontweight='bold')
axs[5].set_xticks([])
axs[5].axvspan(19, 20, color='green', alpha=0.3)
axs[5].axvspan(9, 10, color='pink', alpha=0.6)
axs[5].axvspan(39, 40, color='pink', alpha=0.6)
axs[5].axvspan(59, 60, color='green', alpha=0.3)

axs[0].text(10, 12, 'Pickup C1', fontsize=14, ha='center', va='bottom', color='red')
axs[0].text(20, 12, 'Handover C1', fontsize=14, ha='center', va='bottom', color='green')
axs[0].text(40, 12, 'Pickup C2', fontsize=14, ha='center', va='bottom', color='red')
axs[0].text(57.5, 12, 'Handover C2', fontsize=14, ha='center', va='bottom', color='green')
axs[0].grid(True)
axs[0].legend(loc='upper left', fontsize=13)

for i in range(1, 6):
    axs[i].grid(True)
    axs[i].legend(loc='upper right', fontsize=13)

plt.tight_layout(rect=[0, 0.03, 1, 1])

plt.show()