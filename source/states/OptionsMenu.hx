package states;

import options.Options;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.api.FlxGameJolt;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;
	public var acceptInput:Bool = true;

	var categories:Array<OptionCategory> = [];
	var currentCategory:OptionCategory;
	var selected:Int = 0;
	var categorySelection:Int = 0;
	var inCategory:Bool = false;
	var rows:FlxTypedGroup<Alphabet>;
	var decorations:FlxTypedGroup<FlxSprite>;
	var values:Array<FlxText> = [];
	var checks:Array<FlxSprite> = [];
	var leftSelector:Alphabet;
	var rightSelector:Alphabet;
	var hint:FlxText;
	var displayedLanguage:Dynamic;
	var holdTime:Float = 0;

	override function load()
	{
		categories = [
			new OptionCategory("Preferences", [
				new DownscrollOption(""), new SplashOption(""), new ProgressOption(""),
				new LangOption(""), new MouseOption(""), new FPSOption(""), new ShowFPSOption("")
			]),
			new OptionCategory("Controls", [new DFJKOption(controls), new UIKeyOption(controls)]),
			new OptionCategory("Account", [new AccountOption("")]),
			new OptionCategory("Exit", [])
		];
		if (FlxGameJolt.initialized)
		{
			categories[2].addOption(new DataOption(""));
			categories[2].addOption(new AutoSyncOption(""));
		}
		LoadingState.progress = 100;
		super.load();
	}

	override function create()
	{
		instance = this;
		displayedLanguage = FlxG.save.data.lang;
		var bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		bg.color = 0xFFea71fd;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);

		rows = new FlxTypedGroup<Alphabet>();
		decorations = new FlxTypedGroup<FlxSprite>();
		add(rows);
		add(decorations);
		leftSelector = new Alphabet(0, 0, ">", true);
		rightSelector = new Alphabet(0, 0, "<", true);
		add(leftSelector);
		add(rightSelector);
		var bottom = new FlxSprite(0, FlxG.height - 30).makeGraphic(FlxG.width, 30, FlxColor.BLACK);
		bottom.alpha = 0.6;
		add(bottom);
		hint = new FlxText(10, FlxG.height - 26, FlxG.width - 20, "", 16);
		hint.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
		add(hint);
		showCategories();
		super.create();
	}

	function clearRows():Void
	{
		for (row in rows.members) if (row != null) row.destroy();
		for (decoration in decorations.members) if (decoration != null) decoration.destroy();
		rows.clear();
		decorations.clear();
		values = [];
		checks = [];
	}

	function showCategories():Void
	{
		clearRows();
		inCategory = false;
		selected = categorySelection;
		for (i in 0...categories.length)
		{
			var row = new Alphabet(0, 0, Language.translate(categories[i].getName()), true);
			row.x = (FlxG.width - row.sumwidth) / 2;
			row.y = FlxG.height / 2 + (i - (categories.length - 1) / 2) * 92 - 35;
			rows.add(row);
		}
		hint.text = Language.translate("Use arrows to select, ENTER to play, ESC to return");
		changeSelection();
	}

	function showCategory(category:OptionCategory):Void
	{
		clearRows();
		currentCategory = category;
		inCategory = true;
		selected = 0;
		for (i in 0...category.getOptions().length)
		{
			var option = category.getOptions()[i];
			var row = new Alphabet(100, FlxG.height * 0.48 + i * 100, option.getDisplay(), true, false, false, 0.75, 0.75);
			row.isOption = true;
			rows.add(row);
			var value = new FlxText(750, 0, FlxG.width - 820, "", 24);
			value.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);
			decorations.add(value);
			values.push(value);
			var check:FlxSprite = null;
			if (option.hascheckbox)
			{
				check = new FlxSprite(FlxG.width - 150, 0);
				check.frames = Paths.getSparrowAtlas("checkbox");
				check.animation.addByPrefix("none", "checkbox0", 24, false);
				check.animation.addByPrefix("check", "checkbox anim0", 24, false);
				check.animation.addByPrefix("uncheck", "checkbox anim reverse", 24, false);
				check.animation.addByPrefix("finish", "checkbox finish", 24, false);
				check.animation.play(option.updateCheck() ? "finish" : "none");
				check.setGraphicSize(0, 62);
				check.updateHitbox();
				check.antialiasing = true;
				decorations.add(check);
			}
			checks.push(check);
			refreshOption(i);
		}
		hint.text = Language.translate("Use arrows to change values, ENTER to select, ESC to return");
		changeSelection();
	}

	function refreshOption(index:Int):Void
	{
		var option = currentCategory.getOptions()[index];
		rows.members[index].reType(option.getDisplay(), 0.75, 0.75);
		values[index].text = option.getDisplay2().join("  ");
	}

	function changeSelection(change:Int = 0):Void
	{
		if (rows.length == 0) return;
		selected = FlxMath.wrap(selected + change, 0, rows.length - 1);
		for (i in 0...rows.length)
		{
			var row = rows.members[i];
			row.alpha = i == selected ? 1 : 0.6;
			if (inCategory)
			{
				row.targetY = i - selected;
				values[i].alpha = row.alpha;
				if (checks[i] != null) checks[i].alpha = row.alpha;
			}
		}
		holdTime = 0;
		if (change != 0) FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
	}

	function adjustOption(direction:Int):Void
	{
		var option = currentCategory.getOptions()[selected];
		if (!option.getAccept()) return;
		if (direction < 0 ? option.left() : option.right()) refreshOption(selected);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (displayedLanguage != FlxG.save.data.lang)
		{
			displayedLanguage = FlxG.save.data.lang;
			if (inCategory)
			{
				for (i in 0...rows.length) refreshOption(i);
				hint.text = Language.translate("Use arrows to change values, ENTER to select, ESC to return");
			}
			else showCategories();
		}
		leftSelector.visible = rightSelector.visible = !inCategory && rows.length > 0;
		if (!inCategory && rows.length > 0)
		{
			var row = rows.members[selected];
			leftSelector.setPosition(row.x - leftSelector.sumwidth - 20, row.y);
			rightSelector.setPosition(row.x + row.sumwidth + 20, row.y);
		}
		if (inCategory)
		{
			for (i in 0...rows.length)
			{
				values[i].y = rows.members[i].y + 15;
				if (checks[i] != null) checks[i].y = rows.members[i].y - 5;
			}
		}
		if (!acceptInput) return;
		if (controls.BACK)
		{
			if (inCategory) showCategories();
			else
			{
				MainMenuState.optioned = true;
				MainMenuState.storied = true;
				LoadingState.loadAndSwitchState(() -> new MainMenuState(), false, 1);
			}
			return;
		}
		if (controls.UP_UI || FlxG.mouse.wheel > 0) changeSelection(-1);
		if (controls.DOWN_UI || FlxG.mouse.wheel < 0) changeSelection(1);
		if (inCategory)
		{
			if (controls.LEFT_UI) adjustOption(-1);
			else if (controls.RIGHT_UI) adjustOption(1);
			if (controls.LEFT_UI_H || controls.RIGHT_UI_H)
			{
				holdTime += elapsed;
				if (holdTime >= 0.53)
				{
					adjustOption(controls.LEFT_UI_H ? -1 : 1);
					holdTime = 0.48;
				}
			}
			else holdTime = 0;
		}
		var accept = controls.ACCEPT;
		if (MusicBeatState.mouseA && FlxG.mouse.justPressed)
		{
			for (i in 0...rows.length)
			{
				var row = rows.members[i];
				if (FlxG.mouse.viewX >= row.x && FlxG.mouse.viewX < row.x + row.width
					&& FlxG.mouse.viewY >= row.y && FlxG.mouse.viewY < row.y + row.height)
				{
					if (selected == i) accept = true;
					else changeSelection(i - selected);
					break;
				}
			}
		}
		if (accept)
		{
			if (inCategory)
			{
				var option = currentCategory.getOptions()[selected];
				if (option.press())
				{
					refreshOption(selected);
					if (option.hascheckbox && checks[selected] != null)
						checks[selected].animation.play(option.updateCheck() ? "check" : "uncheck");
				}
			}
			else if (categories[selected].getName() == "Exit")
			{
				MainMenuState.optioned = true;
				MainMenuState.storied = true;
				LoadingState.loadAndSwitchState(() -> new MainMenuState(), false, 1);
			}
			else
			{
				categorySelection = selected;
				showCategory(categories[selected]);
			}
		}
	}

	public function updateAccount():Void
	{
		if (categories[2].getOptions().length == 1)
		{
			categories[2].addOption(new DataOption(""));
			categories[2].addOption(new AutoSyncOption(""));
		}
		showCategory(categories[2]);
		add(new Welcome());
	}

	override function destroy()
	{
		FlxG.save.flush();
		if (instance == this) instance = null;
		super.destroy();
	}
}
