// lib/pages/faq/faq_data.dart
import 'package:cbb_bluechips_mobile/models/faq_models.dart';

const faqs = <Faq>[
  Faq(
    question: 'What is CBB Blue Chips?',
    answer: [
      FaqTextLine(
        "CBB Blue Chips is a free to play online fantasy sports game that revolves around the annual Men's College Basketball Tournament in March.",
      ),
    ],
  ),
  Faq(
    question: 'How do you play CBB Blue Chips?',
    answer: [
      FaqTextLine(
        "Upon signing up, players are given 100,000 fantasy points to buy and sell shares of teams they believe will perform well in the tournament.",
      ),
      FaqTextLine(
        "Team share values change solely based on whether or not teams are able to beat the point spreads of the games they participate in.",
      ),
      FaqTextLine(
        "Throughout the tournament, you can buy and sell shares as often as you'd like (except when teams are playing games). The player with the most points at the end of the tournament wins!",
      ),
    ],
  ),
  Faq(
    question: 'Why was CBB Blue Chips created?',
    answer: [
      FaqTextLine(
        "Having your bracket go haywire after a couple of unexpected games really sucks. So rather than sit out and do nothing, we decided to create a better alternative instead!",
      ),
      FaqTextLine(
        "Here you can trade, strategize, and out play the competition all tournament long!",
      ),
    ],
  ),
  Faq(
    question:
        'Are you affiliated with the NCAA®, the March Madness® Tournament, or any of the collegiate teams shown on the site?',
    answer: [
      FaqTextLine(
        "No. We are in no way affiliated with the NCAA®, the March Madness® Tournament, or any of the collegiate basketball teams shown on this site.",
      ),
      FaqTextLine(
        "Any reference to teams, games, and game scores are purely informational, so that players of our game can make decisions related to playing CBB Blue Chips.",
      ),
    ],
  ),
  Faq(
    question: 'Do my points in CBB Blue Chips have any real value?',
    answer: [
      FaqTextLine(
        "Nope, it's all just part of the game! In CBB Blue Chips, when we talk about buying, selling, trading, or any other type of transaction, remember it's all just for fun. The points don't have any real world value.",
      ),
    ],
  ),
  Faq(
    question: "What Causes a Team's Share Value to Change?",
    answer: [
      FaqTextLine(
        "Team share values are adjusted based on their performances in real-life tournament games.",
      ),
      FaqTextLine(
        "The primary factor in determining team performance is the point spread of each game. Unlike traditional point spreads, in our game, the point spread is only set once for each team at the start of each game day.",
      ),
      FaqTextLine(
        "A team's share value increases if it beats the point spread and decreases if it does not. This means a team's value can rise even if it loses a game, or fall even if it wins, depending solely on its performance relative to the point spread.",
      ),
      FaqTextLine(
        "After a team is eliminated from the tournament, their new share value becomes finalized, as they are no longer active in the competition.",
      ),
    ],
  ),
  Faq(
    question: 'How Are New Share Values Calculated?',
    answer: [
      FaqTextLine(
        "Share values for teams are updated exclusively after the completion of real-life games.",
      ),
      FaqTextLine(
        "The team that beats the point spread will see an increase in value, whereas the team that does not will see a decrease.",
      ),
      FaqTextLine(
        "The extent to which a team beats or fails to meet the point spread determines the magnitude of their value change. Covering the spread by a larger margin results in greater increases in value, and failing by a wider margin leads to corresponding decreases.",
      ),
      FaqTextLine(
        "It's important to note here that the algorithm is weighted in the sense that the first few points above or below the point spread will have a greater impact on share values than any additional points. This is to prevent teams from having their share values skyrocket or plummet after a single game.",
      ),
      FaqTextLine(
        "Additionally, the calculation includes a 'round factor', which escalates with each tournament round, making share value fluctuations more significant as the tournament progresses.",
      ),
      FaqLinkLine(
        before: 'Please visit the ',
        linkText: 'Calculator',
        link: '/calculator', // internal route
        after: ' page to play around with different scenarios!',
      ),
    ],
    tip: FaqTip(
      type: FaqTipType.info,
      text:
          'Note that share value decreases are only half as severe as increases.',
    ),
  ),
  Faq(
    question: 'What Strategy Should I Use to Do Well?',
    answer: [
      FaqTextLine(
        "To excel in playing CBB Blue Chips, it's crucial to make informed decisions based on team performance.",
      ),
      FaqTextLine(
        "Since the value of shares in our game reflects the real-life performances of the teams, selecting teams that you anticipate will perform well is a key strategy.",
      ),
    ],
    tip: FaqTip(
      type: FaqTipType.info,
      text: "Even if a team loses, their share value won't fall to zero.",
    ),
  ),
  Faq(
    question: 'What Defines a "Blue Chip" in This Context?',
    answer: [
      FaqTextLine(
        'In our game, a "CBB Blue Chip" is a college basketball team that consistently beats the point spread thereby increasing its share value. Spotting these teams is key to winning.',
      ),
    ],
  ),
  Faq(
    question: 'When Can I Purchase Shares in a Team?',
    answer: [
      FaqTextLine(
        'Shares can be purchased whenever you see a team unlocked on the market. Teams are locked from trading from the start of their game until the final score is confirmed.',
      ),
      FaqTextLine(
        'The availability of teams varies; only those scheduled to play in the next wave will be listed. One caveat to this is that on non-game days, upcoming teams will be shown.',
      ),
    ],
  ),
  Faq(
    question:
        'A team I invested in won the game, why did their share value drop?',
    answer: [
      FaqTextLine(
        "Share value changes are based on the point spread rather than the game's outcome (win or loss).",
      ),
      FaqTextLine(
        'Due to this, teams that lose may potentially see an increase in value and teams that win may sometimes decrease in value.',
      ),
    ],
  ),
  Faq(
    question: 'When is the Right Time to Sell My Team Shares?',
    answer: [
      FaqTextLine(
        "You're free to sell shares any time, except when the team is playing a live game, during which they are locked until the game is completed. There are no fees for selling shares.",
      ),
    ],
  ),
  Faq(
    question: 'What Constitutes a Conflict of Interest?',
    answer: [
      FaqTextLine(
        'Owning shares in a team and then attempting to purchase shares of their current opponent is considered a conflict of interest and is therefore not allowed. In such cases, you must sell all shares in the initial team before buying shares in their current opponent.',
      ),
    ],
    tip: FaqTip(
      type: FaqTipType.info,
      text:
          'Purchasing shares in two teams that are not currently opponents, but become opponents later in the tournament does not constitute a conflict of interest.',
    ),
  ),
  Faq(
    question:
        'Is there an advantage to holding shares long-term versus selling quickly?',
    answer: [
      FaqTextLine('No, there is no advantage to holding shares long-term.'),
    ],
    tip: FaqTip(
      type: FaqTipType.info,
      text:
          "It's actually better to sell shares immediately after a team's value increases so you can reinvest those points in another team.",
    ),
  ),
  Faq(
    question: 'Why Are Some Names Highlighted on the Leaderboard?',
    answer: [
      FaqTextLine(
        'Highlighted names indicate VIP status. This is an honorary title for our long-term players, previous winners, or well-known local participants. It holds no additional benefits.',
      ),
    ],
  ),
  Faq(
    question: 'Is There a Chance for Point Spreads to Be Altered?',
    answer: [
      FaqTextLine(
        'Unlike traditional point spreads, CBB Blue Chips only sets point spreads once at the beginning of each day that tournament games take place.',
      ),
    ],
    tip: FaqTip(
      type: FaqTipType.info,
      text:
          'If you find a different point spread elsewhere, it might be a great opportunity!',
    ),
  ),
  Faq(
    question: 'How Many Opportunities Are Available for Earning Points?',
    answer: [
      FaqTextLine(
        'With 67 games in March Madness, each game presents a chance for a team to increase in value. Remember, some games in the first round may overlap, so plan your investments accordingly.',
      ),
    ],
  ),
  Faq(
    question:
        'What is the maximum number of games that can be locked at one time?',
    answer: [
      FaqTextLine(
        'Games are played in only four different locations, which means a maximum of four games can be scheduled simultaneously. If a game is set to begin shortly and none of the four ongoing games are near completion, it is likely that the start time of the upcoming game will be delayed.',
      ),
    ],
  ),
  Faq(
    question: 'Is There a Feature to Conceal My Trading Activity?',
    answer: [
      FaqTextLine(
        'When purchasing shares of a team, players can opt to enable "Stealth Mode" which will hide that particular transaction from the public transaction history page.',
      ),
      FaqTextLine(
        "Transactions stay hidden until the start of that team's next game.",
      ),
    ],
    tip: FaqTip(
      type: FaqTipType.warning,
      text:
          'Selling shares purchased using stealth mode prior to the start of their next game may result in stealth transactions being revealed in the public transaction history.',
    ),
  ),
  Faq(
    question: 'How Do Predictions Work?',
    answer: [
      FaqTextLine(
        'Predictions are an optional way to win additional points by voting on questions related to ongoing games.',
      ),
      FaqTextLine(
        'For an entry fee, players can vote Yes or No depending on what they think the outcome will be.',
      ),
      FaqTextLine(
        "The entry fee for predictions is non-refundable, but you may change your vote as often as you'd like until the associated game begins.",
      ),
    ],
  ),
  Faq(
    question: 'Why Did My Total Points Go Down After Voting on a Prediction?',
    answer: [
      FaqTextLine(
        'When you vote on a prediction, you are effectively forfeiting those points until the outcome of the prediction is revealed. Once the outcome has been determined, you will either win back your points, plus an additional return, or lose the intial cost forever.',
      ),
    ],
  ),
  Faq(
    question: 'How Does the Return Ratio Work for Predictions?',
    answer: [
      FaqTextLine(
        'The return ratio is based entirely on the number of participants on each side of the prediction.',
      ),
      FaqTextLine(
        'Participants on the winning side effectively split the total entry points from participants on the losing side.',
      ),
      FaqTextLine('For instance, say the cost to enter is 1,000 points.'),
      FaqTextLine(
        'If there are 10 players on Yes and 10 players on No, the return ratio will be 1:2 on both sides.',
      ),
      FaqTextLine(
        'Meaning that participants on the winning side will receive back their initial 1,000 points, plus their split of the 10,000 points from the losing side for a total of 2,000 points.',
      ),
    ],
  ),
  Faq(
    question: 'Can I Update My Name or Email?',
    answer: [
      FaqLinkLine(
        before:
            'We currently do not support updating your name or email via the account dashboard, but if you would like to request a change please send an email to ',
        linkText: 'cbb.bluechips@gmail.com',
        link: 'mailto:cbb.bluechips@gmail.com',
        after: ' and we will happily assist you with any changes.',
      ),
    ],
  ),
  Faq(
    question: 'Can I Set Up Notifications for Team Share Value changes?',
    answer: [
      FaqLinkLine(
        before:
            'To receive alerts for team share value changes and other CBB Blue Chips related updates please join our ',
        linkText: 'Discord',
        link: 'https://discord.gg/GVKGgRKzGf',
        after: ' server.',
      ),
    ],
  ),
  Faq(
    question: 'When is the Enrollment Period for New Players?',
    answer: [
      FaqTextLine(
        'Sign-ups open on Selection Sunday and continue until the end of the top 64.',
      ),
    ],
  ),
];
