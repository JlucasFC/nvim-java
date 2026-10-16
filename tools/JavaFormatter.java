import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Map;
import java.util.stream.Collectors;

import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jdt.core.ToolFactory;
import org.eclipse.jdt.core.formatter.CodeFormatter;
import org.eclipse.jdt.core.formatter.DefaultCodeFormatterConstants;
import org.eclipse.jface.text.Document;
import org.eclipse.text.edits.TextEdit;

public class JavaFormatter {
  public static void main(String[] args) throws Exception {
    String source = new BufferedReader(new InputStreamReader(System.in))
        .lines()
        .collect(Collectors.joining("\n"));

    Map<String, String> options = DefaultCodeFormatterConstants.getJavaConventionsSettings();

    options.put(JavaCore.COMPILER_SOURCE, JavaCore.VERSION_25);
    options.put(JavaCore.COMPILER_COMPLIANCE, JavaCore.VERSION_25);
    options.put(JavaCore.COMPILER_CODEGEN_TARGET_PLATFORM, JavaCore.VERSION_25);

    options.put(DefaultCodeFormatterConstants.FORMATTER_LINE_SPLIT, "100");
    options.put(DefaultCodeFormatterConstants.FORMATTER_TAB_CHAR, JavaCore.SPACE);
    options.put(DefaultCodeFormatterConstants.FORMATTER_TAB_SIZE, "4");
    options.put(DefaultCodeFormatterConstants.FORMATTER_INDENTATION_SIZE, "4");
    options.put(DefaultCodeFormatterConstants.FORMATTER_CONTINUATION_INDENTATION, "1");
    options.put(DefaultCodeFormatterConstants.FORMATTER_JOIN_WRAPPED_LINES, DefaultCodeFormatterConstants.FALSE);

    String onePerLine = DefaultCodeFormatterConstants.createAlignmentValue(
        true,
        DefaultCodeFormatterConstants.WRAP_ONE_PER_LINE,
        DefaultCodeFormatterConstants.INDENT_DEFAULT);

    options.put(
        DefaultCodeFormatterConstants.FORMATTER_ALIGNMENT_FOR_ARGUMENTS_IN_ALLOCATION_EXPRESSION,
        onePerLine);
    options.put(
        DefaultCodeFormatterConstants.FORMATTER_ALIGNMENT_FOR_ARGUMENTS_IN_QUALIFIED_ALLOCATION_EXPRESSION,
        onePerLine);
    options.put(
        DefaultCodeFormatterConstants.FORMATTER_ALIGNMENT_FOR_ARGUMENTS_IN_METHOD_INVOCATION,
        onePerLine);
    options.put(
        DefaultCodeFormatterConstants.FORMATTER_ALIGNMENT_FOR_ARGUMENTS_IN_EXPLICIT_CONSTRUCTOR_CALL,
        onePerLine);
    options.put(
        DefaultCodeFormatterConstants.FORMATTER_PARENTHESES_POSITIONS_IN_METHOD_INVOCATION,
        DefaultCodeFormatterConstants.SEPARATE_LINES_IF_WRAPPED);

    CodeFormatter formatter = ToolFactory.createCodeFormatter(options);
    TextEdit edit = formatter.format(
        CodeFormatter.K_COMPILATION_UNIT,
        source,
        0,
        source.length(),
        0,
        "\n");

    if (edit == null) {
      System.err.println("Java formatter could not parse the source.");
      System.exit(1);
    }

    Document document = new Document(source);
    edit.apply(document);
    System.out.print(document.get());
  }
}
