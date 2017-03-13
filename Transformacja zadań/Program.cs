using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Xsl;
using System.IO;

namespace Transformacja_zadań
{
    class Program
    {
        static string ChangeExtension(string filename)
        {
            return filename.Replace(".xml", ".unified.xml");
        }

        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Pass the stylesheet and XML files as arguments");
                return;
            }
            if (!File.Exists(args[0]))
            {
                Console.WriteLine("Stylesheet file does not exist");
                return;
            }

            XslCompiledTransform transform = new XslCompiledTransform();

            transform.Load(args[0]);

            foreach (string filename in args.Skip(1))
            {
                if (!File.Exists(filename))
                {
                    Console.WriteLine("File {0} does not exits", filename);
                    continue;
                }

                transform.Transform(filename, ChangeExtension(filename));
            }
        }
    }
}
