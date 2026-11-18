# Where the game's own scripts call our code (add these lines to your own copy of the scripts)

maps/cuba.gsc (in main, near the top):
    level thread maps\_cubacoop::init(); // CUBACOOP

maps/_anim.gsc (in the single-animation function, where guy plays an animation):
    if ( IsDefined( guy.cc_human ) ) guy thread maps\_cubacoop::scene_start( animation ); // CUBACOOP
