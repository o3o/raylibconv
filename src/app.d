import std.stdio;
import std.getopt;
import std.regex;
struct Fun {

   string ret;
   string name;
   string args;
   size_t  row;
}

void main(string[] args) {
   import std.stdio : File;
   import std.format : format;
   import std.algorithm.searching : startsWith;

   bool verbose;
   string inFile;
   string outFile = "out.d";
   string rel = "260";

   enum RET_TYPE = r"(Ray|Rectangle|Image|Matrix|Vector\d?|Color|void|bool|ubyte|ubyte\*|int|float|double|const\(char\)\*)";
   enum FUNC_NAME = r"(\w+)";
   //enum ARGS = r"(\([^;]*)";
   enum ARGS = r"\(([^\)]*)\)\s*;";
   enum REG_STRING = RET_TYPE ~ r"\s+" ~ FUNC_NAME ~ r"\s*" ~ ARGS;
   //string regString = r"%s\s+%s\s*".format(RET_TYPE);


   //auto r = regex(r"(Ray|Rectangle|Image|Matrix|Vector\d?|Color|void|bool|ubyte|ubyte\*|int|float|double|const\(char\)\*)\s+(\w+)\s*");
   auto r = regex(REG_STRING);
   auto opt = getopt(args,
         "verbose|v", "Verbose", &verbose,
         "input|i", "Input file", &inFile,
         "release|r", "Raylib release", &rel,
         "output|o", "Output file", &outFile,
         );

   Fun[] funcs;
   try {
      auto file = File(inFile, "r");
      string line;
      size_t lineNum;

      while ((line = file.readln()) !is null) {
         lineNum++;
         if (!line.startsWith("/")) {
            auto m = matchFirst(line, r);
            if (!m.empty) {
               Fun f;
               f.ret = m[1];
               f.name = m[2];
               f.args = m[3];
               f.row = lineNum;
               if (verbose) {
                  writeln(f) ;
                  //writeln(m[1],"  ", m[2] , " [[ ", m[3], " ]]") ;
               }
               funcs ~= f;
            }
         }
      }
      auto of = File(outFile, "w");
      of.writefln("module bindbc.raylib.bind.raylib%s;", rel);


      of.writeln();
      of.writeln("import bindbc.raylib.config;");
      of.writeln("import bindbc.raylib.types;");
      of.writeln();

      of.writeln("extern(System) @nogc nothrow {");


      foreach (f; funcs) {
         of.writefln("   alias p%s = %s function(%s);", f.name, f.ret, f.args);
      }
      of.writeln("}");
      of.writeln();
      of.writeln("__gshared {");
      foreach (f; funcs) {
         of.writefln("   p%s %s;", f.name, f.name);
      }
      of.writeln("}");
      of.writeln();

      of.writefln("bool load%s(SharedLib lib) {", rel);
      of.writeln("   auto startErrCount = errorCount();");
      of.writeln();
      foreach (f; funcs) {
         of.writefln(`   lib.bindSymbol(cast(void**)&%s, "%s");`, f.name, f.name);
      }

      of.writeln();
      of.writeln("   return errorCount() == startErrCount;");
      of.writeln("}");

   } catch (Exception ex) {
      writeln(ex.msg);
   }
}
