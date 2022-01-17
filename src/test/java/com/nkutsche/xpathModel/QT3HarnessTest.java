package com.nkutsche.xpathModel;


import org.junit.Before;
import org.junit.Test;
import org.basex.tests.w3c.QT3TS;
import org.w3c.dom.Document;
import org.xmlunit.matchers.CompareMatcher;
import sun.misc.IOUtils;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.dom.DOMSource;

import java.io.File;

import static org.junit.Assert.assertThat;
import static org.xmlunit.matchers.CompareMatcher.isIdenticalTo;


public class QT3HarnessTest {

    public static DocumentBuilder docBuilder;


    @Before
    public void before(){
        if(docBuilder == null){
            try {
                docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            } catch (ParserConfigurationException e) {
                e.printStackTrace();
                throw new IllegalStateException(e);
            }
        }

    }


    @Test
    public void testQt3() throws Exception {
        String beforeReport = "target/qts3-report-before.xml";
        String afterReport = "target/qts3-report-after.xml";

//      executes QT3-Testsuite driver from BaseX without any modification:
        QT3TS.main("-ptarget/testsuite/", "-r" + beforeReport, "-ltarget/qts3-report-before.log");

//      executes QT3-Testsuite dirver with the modified testsuite
        QT3TS.main("-ptarget/testsuite-conv/", "-r" + afterReport, "-ltarget/qts3-report-after.log");

//        parses both test reports
        Document beforeReportDoc = docBuilder.parse(new File(beforeReport));
        Document afterReportDoc = docBuilder.parse(new File(afterReport));

//      compares both test reports - no change should occur
        assertThat("Differences in Accessibility structure...", new DOMSource(beforeReportDoc), matches(afterReportDoc));



    }

    private CompareMatcher matches(Document expectedOutput) {
        return matches(new DOMSource(expectedOutput));
    }
    private CompareMatcher matches(DOMSource expectedOutput) {

        return isIdenticalTo(expectedOutput)
                .normalizeWhitespace()
                .ignoreComments()
                .throwComparisonFailure();
    }

}
