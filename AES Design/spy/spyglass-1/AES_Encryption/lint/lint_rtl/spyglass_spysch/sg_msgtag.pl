################################################################################
#This is an internally genertaed by spyglass for Message Tagging Support
################################################################################


        use spyglass;
    use SpyGlass;
    use SpyGlass::Objects;
    spyRebootMsgTagSupport();

    spySetMsgTagCount(95,34);
spyParseTextMessageTagFile("./spyglass-1/AES_Encryption/lint/lint_rtl/spyglass_spysch/sg_msgtag.txt");

spyMessageTagTestBenchmark(5,"./spyglass-1/AES_Encryption/lint/lint_rtl/spyglass.vdb");

1;