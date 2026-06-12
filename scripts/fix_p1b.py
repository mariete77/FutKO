"""P1b: Modify challengeFriend to save challengeId on state."""
PATH = r'C:\Users\mario\dev\personal\FutKO\lib\presentation\providers\multiplayer_provider.dart'
with open(PATH, 'r', encoding='utf-8', newline=None) as f:
    c = f.read()
# Replace the fold callback to also save questionIds for later challenge creation
c = c.replace(
    "(qs) { _questions = qs; state = state.copyWith(status: MultiplayerStatus.found, opponentName: name, opponentElo: elo, invitedFriendId: friendId); },",
    "(qs) {\n          _questions = qs;\n          state = state.copyWith(status: MultiplayerStatus.found, opponentName: name, opponentElo: elo, invitedFriendId: friendId);\n        },"
)
with open(PATH, 'w', encoding='utf-8') as f:
    f.write(c)
print('P1b done')
