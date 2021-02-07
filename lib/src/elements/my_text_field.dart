// how can I possibly move my TextField with its 2 input check functions into a separate class
// this has been a huge pain in the ass with me trying a bunch of times and wasting so much time on each failed attempt

// I tried for this class to be Stateless and pass the controller
// but then if controller is final it doesnt work and if its not final then this solution is a gimmic
// becaue fields in a stateless widget are supposed to be immutable

// if this class is statefull and the controller is declared and initialized with in it which would be ideal
// you have to 1. have a referance to this TextField in HomePage so you can call the getValue function which fixes input
// and 2. you cant even access the controller value becaue its declared in state and not the widget itself

// this way of state management is so stupid its fucking beyond me
// stick everything in one file have a 1000 lines of code and everything will work
// very cool
// go fuck yourself

// other issues
// - cursor offset goes to 0 after setting controller.text for no apparent reason
// - the workaround is to manually set it back to controller.length or what ever
