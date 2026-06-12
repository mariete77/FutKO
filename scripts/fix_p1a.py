"""P1a: Add challengeId to MultiplayerState."""
PATH = r'C:\Users\mario\dev\personal\FutKO\lib\presentation\providers\multiplayer_provider.dart'
with open(PATH, 'r', encoding='utf-8', newline=None) as f:
    c = f.read()
# Add field
c = c.replace("  final String? invitedFriendId;\n\n  const MultiplayerState({", "  final String? invitedFriendId;\n  final String? challengeId;\n\n  const MultiplayerState({")
# Add constructor param
c = c.replace("    this.invitedFriendId,\n  });", "    this.invitedFriendId,\n    this.challengeId,\n  });")
# Add copyWith param
c = c.replace("    String? invitedFriendId,\n  }) {", "    String? invitedFriendId,\n    String? challengeId,\n  }) {")
# Add copyWith body
c = c.replace("      invitedFriendId: invitedFriendId ?? this.invitedFriendId,\n    );\n  }\n}", "      invitedFriendId: invitedFriendId ?? this.invitedFriendId,\n      challengeId: challengeId ?? this.challengeId,\n    );\n  }\n}")
with open(PATH, 'w', encoding='utf-8') as f:
    f.write(c)
print('P1a done')
