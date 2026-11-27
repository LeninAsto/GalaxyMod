package states;

#if desktop
import backend.integration.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class FreeplayState extends MusicBeatState
{
	public var songs:Array<SongMetadata> = [];
	var selected:Int = 0;
	var difficulty:Int = 1;
	var rows:FlxTypedGroup<Alphabet>;
	var authors:FlxTypedGroup<Alphabet>;
	var icons:Array<HealthIcon> = [];
	var bg:FlxSprite;
	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var difficultyText:FlxText;
	var detailText:FlxText;
	var score:Int = 0;
	var accuracy:Float = 0;
	var combo:Int = 0;
	var targetScore:Int = 0;
	var targetAccuracy:Float = 0;
	var targetCombo:Int = 0;
	var colorTween:FlxTween;
	var colors:Array<Int> = [0xFF9271fd, 0xFF1adbdf, 0xFFffd101, 0xFFc262e3];
	var specialSongs:Array<String> = ["Kastimagina", "Cyber", "Peace"];
	var specialWeeks:Array<Int> = [1, 2, 3];

	override function load()
	{
		var debugUnlocks = false;
		#if nomorelocks
		debugUnlocks = true;
		#end
		for (song in CoolUtil.coolTextFile(Paths.txt("freeplaySonglist")))
			addSong(song, 0, "gf", "Kawai Sprite");
		addWeek(["Galaxy", "Game"], 1, ["kastimagina"], ["Allen98637"]);
		if (StoryMenuState.weekPassed[1].contains(true) || debugUnlocks)
		{
			addSong("Kastimagina", 1, "kastimagina", "Allen98637");
			#if (desktop || web)
			addSong("Familanna", 1, "kastimagina", "Allen98637");
			#end
		}
		addWeek(["Cona", "Underworld"], 2, ["kalisa"], ["Allen98637"]);
		if (StoryMenuState.weekPassed[2].contains(true) || debugUnlocks)
		{
			#if desktop
			addSong("Cyber", 2, "kalisa", "Allen98637");
			#end
		}
		addWeek(["Newton", "Destiny"], 3, ["unknown"], ["Allen98637"]);
		if (StoryMenuState.weekPassed[3].contains(true) || debugUnlocks)
		{
			#if (desktop || web)
			addSong("Peace", 3, "unknown", "Allen98637");
			#end
		}
		for (i in 0...songs.length)
		{
			FlxG.sound.create(Paths.inst(songs[i].songName)).setup(0);
			LoadingState.progress = Std.int((i + 1) / songs.length * 100);
		}
		super.load();
	}

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end
		bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		bg.antialiasing = FlxG.save.data.antialiasing;
		bg.screenCenter();
		add(bg);
		rows = new FlxTypedGroup<Alphabet>();
		add(rows);
		authors = new FlxTypedGroup<Alphabet>();
		add(authors);
		for (i in 0...songs.length)
		{
			var row = new Alphabet(0, 30 + i * 70, songs[i].songName, true);
			row.isMenuItem = true;
			rows.add(row);
			var author = new Alphabet(0, 0, "- " + songs[i].songAuthor, false, false, false, 0.45, 0.45);
			authors.add(author);
			var icon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = row;
			icons.push(icon);
			add(icon);
		}
		scoreBG = new FlxSprite(FlxG.width * 0.68, 0).makeGraphic(Std.int(FlxG.width * 0.32), 120, FlxColor.WHITE);
		scoreBG.alpha = 0.6;
		add(scoreBG);
		var font = FlxG.save.data.lang == 1 ? "taipei.ttf" : "vcr.ttf";
		scoreText = new FlxText(scoreBG.x + 10, 8, scoreBG.width - 20, "", 25);
		scoreText.setFormat(Paths.font(font), 25, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		add(scoreText);
		difficultyText = new FlxText(scoreBG.x + 10, 40, scoreBG.width - 20, "", 23);
		difficultyText.setFormat(Paths.font(font), 23, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		add(difficultyText);
		detailText = new FlxText(scoreBG.x + 10, 70, scoreBG.width - 20, "", 19);
		detailText.setFormat(Paths.font(font), 19, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		add(detailText);
		var bottom = new FlxSprite(0, FlxG.height - 28).makeGraphic(FlxG.width, 28, FlxColor.BLACK);
		bottom.alpha = 0.6;
		add(bottom);
		var hint = new FlxText(10, FlxG.height - 25, FlxG.width - 20,
			Language.translate("Use arrows to select, ENTER to play, ESC to return"), 16);
		hint.setFormat(Paths.font(font), 16, FlxColor.WHITE, CENTER);
		add(hint);
		changeSelection();
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songAuthor:String)
		songs.push(new SongMetadata(songName, weekNum, songCharacter, songAuthor));

	public function addWeek(songNames:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?songAuthors:Array<String>)
	{
		if (songCharacters == null) songCharacters = ["bf"];
		if (songAuthors == null) songAuthors = ["Kawai Sprite"];
		for (i in 0...songNames.length)
			addSong(songNames[i], weekNum, songCharacters[songCharacters.length == 1 ? 0 : i],
				songAuthors[songAuthors.length == 1 ? 0 : i]);
	}

	function availableDifficulties():Array<Int>
	{
		var specialIndex = specialSongs.indexOf(songs[selected].songName);
		if (specialIndex < 0) return [0, 1, 2];
		var result:Array<Int> = [];
		var unlocked = StoryMenuState.weekPassed[specialWeeks[specialIndex]];
		for (i in 0...unlocked.length) if (unlocked[i]) result.push(i);
		#if debug
		if (result.length == 0) return [0, 1, 2];
		#end
		return result;
	}

	function changeDifficulty(change:Int = 0):Void
	{
		var available = availableDifficulties();
		if (available.length == 0) return;
		var index = available.indexOf(difficulty);
		if (index < 0) index = 0;
		else index = FlxMath.wrap(index + change, 0, available.length - 1);
		difficulty = available[index];
		var names = ["EASY", "NORMAL", "HARD", "TRUE"];
		difficultyText.text = "< " + Language.translate(names[difficulty]) + " >";
		#if !switch
		targetScore = Highscore.getScore(songs[selected].songName, difficulty);
		targetAccuracy = Highscore.getAcc(songs[selected].songName, difficulty);
		targetCombo = Highscore.getCombo(songs[selected].songName, difficulty);
		#end
	}

	function changeSelection(change:Int = 0):Void
	{
		if (songs.length == 0) return;
		selected = FlxMath.wrap(selected + change, 0, songs.length - 1);
		if (change != 0) FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
		for (i in 0...rows.length)
		{
			rows.members[i].targetY = i - selected;
			rows.members[i].alpha = i == selected ? 1 : 0.6;
			authors.members[i].alpha = rows.members[i].alpha;
			icons[i].alpha = rows.members[i].alpha;
		}
		var songColor = colors[songs[selected].week];
		if (colorTween != null) colorTween.cancel();
		colorTween = FlxTween.color(bg, 0.5, bg.color, songColor);
		changeDifficulty();
		if (FlxG.sound.music != null && FlxG.sound.music.fadeTween != null)
			FlxG.sound.music.fadeTween.cancel();
		FlxG.sound.playMusic(Paths.inst(songs[selected].songName), null, 0.7, true);
	}

	function scoreColor(hover:Bool):FlxColor
	{
		if (targetAccuracy == 100) return hover ? 0xFFFFFF64 : 0xFFFED700;
		if (targetAccuracy >= 95) return hover ? 0xFFFFFFFF : 0xFFEAEAEA;
		if (targetAccuracy >= 90) return hover ? 0xFFFF64FF : 0xFFFF00DD;
		if (targetAccuracy >= 80) return hover ? 0xFFFF6464 : 0xFFFF0000;
		if (targetAccuracy >= 70) return hover ? 0xFF64FF64 : 0xFF00FF00;
		if (targetAccuracy > 0) return hover ? 0xFFEBEBEB : 0xFF878787;
		return hover ? 0xFF646464 : 0xFF000000;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (songs.length == 0) return;
		for (i in 0...rows.length)
		{
			authors.members[i].setPosition(rows.members[i].x + 20, rows.members[i].visualBaseline - 25);
		}
		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume = Math.min(0.7, FlxG.sound.music.volume + 0.5 * elapsed);
		var scoreFactor = 1 - Math.exp(-elapsed * 24);
		var accuracyFactor = 1 - Math.exp(-elapsed * 12);
		score = Math.round(FlxMath.lerp(score, targetScore, scoreFactor));
		accuracy = FlxMath.lerp(accuracy, targetAccuracy, accuracyFactor);
		combo = Math.round(FlxMath.lerp(combo, Math.abs(targetCombo), scoreFactor));
		if (Math.abs(score - targetScore) < 10) score = targetScore;
		if (Math.abs(accuracy - targetAccuracy) < 0.01) accuracy = targetAccuracy;
		if (Math.abs(combo - Math.abs(targetCombo)) < 5) combo = Std.int(Math.abs(targetCombo));
		scoreText.text = (FlxG.save.data.lang == 1 ? "個人紀錄:" : Language.translate("PERSONAL BEST:")) + " " + score;
		detailText.text = (FlxG.save.data.lang == 1 ? "準確度:" : Language.translate("Accuracy:")) + " "
			+ (Math.round(accuracy * 100) / 100) + "%\n"
			+ (FlxG.save.data.lang == 1 ? "連擊:" : Language.translate("Combo:")) + " " + combo + (targetCombo < 0 ? " (FC)" : "");
		if (controls.UP_UI || FlxG.mouse.wheel > 0) changeSelection(-1);
		if (controls.DOWN_UI || FlxG.mouse.wheel < 0) changeSelection(1);
		if (controls.LEFT_UI) changeDifficulty(-1);
		if (controls.RIGHT_UI) changeDifficulty(1);
		var accept = controls.ACCEPT;
		var overScore = FlxG.mouse.viewX >= scoreBG.x && FlxG.mouse.viewX < scoreBG.x + scoreBG.width
			&& FlxG.mouse.viewY >= scoreBG.y && FlxG.mouse.viewY < scoreBG.y + scoreBG.height;
		scoreBG.color = scoreColor(overScore);
		if (MusicBeatState.mouseA && FlxG.mouse.justPressed)
		{
			if (overScore)
				changeDifficulty(1);
			else for (i in 0...rows.length)
			{
				var row = rows.members[i];
				var icon = icons[i];
				var onRow = FlxG.mouse.viewX >= row.x && FlxG.mouse.viewX < row.x + row.width
					&& FlxG.mouse.viewY >= row.y && FlxG.mouse.viewY < row.y + row.height;
				var onIcon = FlxG.mouse.viewX >= icon.x && FlxG.mouse.viewX < icon.x + icon.width
					&& FlxG.mouse.viewY >= icon.y && FlxG.mouse.viewY < icon.y + icon.height;
				if (onRow || onIcon)
				{
					if (i == selected) accept = true;
					else changeSelection(i - selected);
					break;
				}
			}
		}
		if (controls.BACK)
		{
			MainMenuState.storied = true;
			LoadingState.loadAndSwitchState(() -> new MainMenuState(), false, 1);
		}
		else if (accept && (songs[selected].songName != "Familanna" || difficulty == 0))
		{
			var name = songs[selected].songName.toLowerCase();
			PlayState.SONG = Song.loadFromJson(Highscore.formatSong(name, difficulty), name);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = difficulty;
			PlayState.storyWeek = songs[selected].week;
			LoadingState.loadAndSwitchState(() -> new PlayState(), true);
		}
	}

	override function destroy()
	{
		if (colorTween != null) colorTween.cancel();
		super.destroy();
	}
}

class SongMetadata
{
	public var songName:String;
	public var week:Int;
	public var songCharacter:String;
	public var songAuthor:String;
	public function new(song:String, week:Int, songCharacter:String, author:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songAuthor = author;
	}
}
