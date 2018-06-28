trigger helloTestTrigger on Account (before insert) {
    HelloTest.addHelloWorld(Trigger.new);
}