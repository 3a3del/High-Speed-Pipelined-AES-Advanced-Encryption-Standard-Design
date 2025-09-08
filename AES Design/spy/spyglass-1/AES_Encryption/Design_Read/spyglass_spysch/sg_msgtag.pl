################################################################################
#This is an internally genertaed by spyglass for Message Tagging Support
################################################################################


        use spyglass;
    use SpyGlass;
    use SpyGlass::Objects;
    spyRebootMsgTagSupport();

    spySetMsgTagCount(6,34);
spyParseTextMessageTagFile("./spyglass-1/AES_Encryption/Design_Read/spyglass_spysch/sg_msgtag.txt");

spyMessageTagTestBenchmark(2,"./spyglass-1/AES_Encryption/Design_Read/spyglass.vdb");

1;