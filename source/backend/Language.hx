package backend;

import flixel.FlxG;

class Language
{
    public static inline var ENGLISH:Int = 0;
    public static inline var CHINESE:Int = 1;
    public static inline var SPANISH:Int = 2;

    static final spanish:Map<String, String> = [
        "Preferences" => "Preferencias", "Controls" => "Controles", "Account" => "Cuenta", "Exit" => "Salir",
        "Gameplay keybinds" => "Teclas de juego", "UI keybinds" => "Teclas de menú", "Downscroll" => "Notas hacia abajo",
        "Progressbar" => "Barra de progreso", "Language" => "Idioma", "notesplash" => "Efectos de notas",
        "mouse" => "Ratón", "show FPS" => "Mostrar FPS", "framerate" => "Fotogramas por segundo",
        "GameJolt Log In" => "Iniciar sesión", "GameJolt Log Out" => "Cerrar sesión", "Data Storage" => "Datos guardados",
        "auto upload" => "Subida automática", "Default" => "Predeterminado", "System" => "Sistema", "None" => "Ninguno",
        "Resume" => "Continuar", "Restart Song" => "Reiniciar canción", "Practice Mode" => "Modo práctica",
        "End Practice" => "Terminar práctica", "Exit to menu" => "Salir al menú",
        "PERSONAL BEST:" => "MEJOR PUNTAJE:", "Accuracy:" => "Precisión:", "Combo:" => "Combo:", "Score:" => "Puntaje:", "Misses:" => "Fallos:", "Rating:" => "Precisión:",
        "EASY" => "FÁCIL", "NORMAL" => "NORMAL", "HARD" => "DIFÍCIL", "TRUE" => "VERDADERO",
        "Tracks" => "Canciones", "WEEK SCORE" => "PUNTAJE SEMANAL",
        "Author:" => "Autor:",
        "Use arrows to change values, ENTER to select, ESC to return" => "Usa las flechas para cambiar, ENTER para elegir y ESC para volver",
        "Use arrows to select, ENTER to play, ESC to return" => "Usa las flechas para elegir, ENTER para jugar y ESC para volver"
    ];

    public static inline function isSpanish():Bool
        return FlxG.save.data.lang == SPANISH;

    public static function dialoguePath(key:String):String
    {
        if (isSpanish())
        {
            var localized = Paths.txt(key + 'Es');
            if (openfl.utils.Assets.exists(localized, TEXT)) return localized;
        }
        return Paths.txt(key);
    }

    public static function translate(text:String):String
    {
        if (text == null || !isSpanish()) return text;
        var translated = spanish.get(text);
        return translated != null ? translated : text;
    }
}
