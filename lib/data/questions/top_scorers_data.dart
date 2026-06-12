/// Top-scorer data for QuestionType.topScorer.
///
/// Maximum goalscorers (Pichichi / Golden Boot / Capocannoniere /
/// Torjägerkanone) from the 1999–2000 season through 2024–25 for the
/// four major European leagues: La Liga, Premier League, Serie A and
/// Bundesliga.
///
/// `year` is the season's ending year (e.g. 2000 = 1999-00 season),
/// matching the convention used in `HonoursData`.
///
/// For seasons with shared winners only one entry is kept (the first
/// player listed by Wikipedia).
class TopScorersData {
  // ── La Liga (España) ──
  static const List<TopScorerEntry> laLiga = [
    TopScorerEntry(2000, 'Salva Ballesta'),
    TopScorerEntry(2001, 'Raúl'),
    TopScorerEntry(2002, 'Diego Tristán'),
    TopScorerEntry(2003, 'Roy Makaay'),
    TopScorerEntry(2004, 'Ronaldo'),
    TopScorerEntry(2005, 'Diego Forlán'), // shared with Samuel Eto'o
    TopScorerEntry(2006, 'Samuel Eto\'o'),
    TopScorerEntry(2007, 'Ruud van Nistelrooy'),
    TopScorerEntry(2008, 'Dani Güiza'),
    TopScorerEntry(2009, 'Diego Forlán'),
    TopScorerEntry(2010, 'Lionel Messi'),
    TopScorerEntry(2011, 'Cristiano Ronaldo'),
    TopScorerEntry(2012, 'Lionel Messi'),
    TopScorerEntry(2013, 'Lionel Messi'),
    TopScorerEntry(2014, 'Cristiano Ronaldo'),
    TopScorerEntry(2015, 'Cristiano Ronaldo'),
    TopScorerEntry(2016, 'Luis Suárez'),
    TopScorerEntry(2017, 'Lionel Messi'),
    TopScorerEntry(2018, 'Lionel Messi'),
    TopScorerEntry(2019, 'Lionel Messi'),
    TopScorerEntry(2020, 'Lionel Messi'),
    TopScorerEntry(2021, 'Lionel Messi'),
    TopScorerEntry(2022, 'Karim Benzema'),
    TopScorerEntry(2023, 'Robert Lewandowski'),
    TopScorerEntry(2024, 'Artem Dovbyk'),
    TopScorerEntry(2025, 'Kylian Mbappé'),
  ];

  // ── Premier League (Inglaterra) ──
  static const List<TopScorerEntry> premierLeague = [
    TopScorerEntry(2000, 'Kevin Phillips'),
    TopScorerEntry(2001, 'Jimmy Floyd Hasselbaink'),
    TopScorerEntry(2002, 'Thierry Henry'),
    TopScorerEntry(2003, 'Ruud van Nistelrooy'),
    TopScorerEntry(2004, 'Thierry Henry'),
    TopScorerEntry(2005, 'Thierry Henry'),
    TopScorerEntry(2006, 'Thierry Henry'),
    TopScorerEntry(2007, 'Didier Drogba'),
    TopScorerEntry(2008, 'Cristiano Ronaldo'),
    TopScorerEntry(2009, 'Nicolas Anelka'),
    TopScorerEntry(2010, 'Didier Drogba'),
    TopScorerEntry(2011, 'Dimitar Berbatov'), // shared with Carlos Tévez
    TopScorerEntry(2012, 'Robin van Persie'),
    TopScorerEntry(2013, 'Robin van Persie'),
    TopScorerEntry(2014, 'Luis Suárez'),
    TopScorerEntry(2015, 'Sergio Agüero'),
    TopScorerEntry(2016, 'Harry Kane'),
    TopScorerEntry(2017, 'Harry Kane'),
    TopScorerEntry(2018, 'Mohamed Salah'),
    TopScorerEntry(2019, 'Mohamed Salah'), // shared with Mané & Aubameyang
    TopScorerEntry(2020, 'Jamie Vardy'),
    TopScorerEntry(2021, 'Harry Kane'),
    TopScorerEntry(2022, 'Mohamed Salah'), // shared with Son Heung-min
    TopScorerEntry(2023, 'Erling Haaland'),
    TopScorerEntry(2024, 'Erling Haaland'),
    TopScorerEntry(2025, 'Mohamed Salah'),
  ];

  // ── Serie A (Italia) ──
  static const List<TopScorerEntry> serieA = [
    TopScorerEntry(2000, 'Andriy Shevchenko'),
    TopScorerEntry(2001, 'Hernán Crespo'),
    TopScorerEntry(2002, 'David Trezeguet'), // shared with Dario Hübner
    TopScorerEntry(2003, 'Christian Vieri'),
    TopScorerEntry(2004, 'Andriy Shevchenko'),
    TopScorerEntry(2005, 'Cristiano Lucarelli'),
    TopScorerEntry(2006, 'Luca Toni'),
    TopScorerEntry(2007, 'Francesco Totti'),
    TopScorerEntry(2008, 'Alessandro Del Piero'),
    TopScorerEntry(2009, 'Zlatan Ibrahimović'),
    TopScorerEntry(2010, 'Antonio Di Natale'),
    TopScorerEntry(2011, 'Antonio Di Natale'),
    TopScorerEntry(2012, 'Zlatan Ibrahimović'),
    TopScorerEntry(2013, 'Edinson Cavani'),
    TopScorerEntry(2014, 'Ciro Immobile'),
    TopScorerEntry(2015, 'Mauro Icardi'), // shared with Luca Toni
    TopScorerEntry(2016, 'Gonzalo Higuaín'),
    TopScorerEntry(2017, 'Edin Džeko'),
    TopScorerEntry(2018, 'Ciro Immobile'), // shared with Mauro Icardi
    TopScorerEntry(2019, 'Fabio Quagliarella'),
    TopScorerEntry(2020, 'Ciro Immobile'),
    TopScorerEntry(2021, 'Cristiano Ronaldo'),
    TopScorerEntry(2022, 'Ciro Immobile'),
    TopScorerEntry(2023, 'Victor Osimhen'),
    TopScorerEntry(2024, 'Lautaro Martínez'),
    TopScorerEntry(2025, 'Mateo Retegui'),
  ];

  // ── Bundesliga (Alemania) ──
  static const List<TopScorerEntry> bundesliga = [
    TopScorerEntry(2000, 'Martin Max'),
    TopScorerEntry(2001, 'Sergej Barbarez'), // shared with Ebbe Sand
    TopScorerEntry(2002, 'Márcio Amoroso'), // shared with Martin Max
    TopScorerEntry(2003, 'Giovane Élber'), // shared with Thomas Christiansen
    TopScorerEntry(2004, 'Aílton'),
    TopScorerEntry(2005, 'Marek Mintál'),
    TopScorerEntry(2006, 'Miroslav Klose'),
    TopScorerEntry(2007, 'Theofanis Gekas'),
    TopScorerEntry(2008, 'Luca Toni'),
    TopScorerEntry(2009, 'Grafite'),
    TopScorerEntry(2010, 'Edin Džeko'),
    TopScorerEntry(2011, 'Mario Gómez'),
    TopScorerEntry(2012, 'Klaas-Jan Huntelaar'),
    TopScorerEntry(2013, 'Stefan Kießling'),
    TopScorerEntry(2014, 'Robert Lewandowski'),
    TopScorerEntry(2015, 'Alexander Meier'),
    TopScorerEntry(2016, 'Robert Lewandowski'),
    TopScorerEntry(2017, 'Pierre-Emerick Aubameyang'),
    TopScorerEntry(2018, 'Robert Lewandowski'),
    TopScorerEntry(2019, 'Robert Lewandowski'),
    TopScorerEntry(2020, 'Robert Lewandowski'),
    TopScorerEntry(2021, 'Robert Lewandowski'),
    TopScorerEntry(2022, 'Robert Lewandowski'),
    TopScorerEntry(2023, 'Niclas Füllkrug'), // shared with Christopher Nkunku
    TopScorerEntry(2024, 'Harry Kane'),
    TopScorerEntry(2025, 'Harry Kane'),
  ];
}

class TopScorerEntry {
  final int year; // season ending year
  final String scorer;
  const TopScorerEntry(this.year, this.scorer);
}
