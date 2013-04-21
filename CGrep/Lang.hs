--
-- Copyright (c) 2013 Bonelli Nicola <bonelli@antifork.org>
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

module CGrep.Lang where

import qualified Data.Map as Map
import System.FilePath(takeExtension)
import Control.Monad 
import Control.Applicative

data Lang = Awk | C | Cpp | Csharp | Css | CMake | D | Erlang | Fsharp | Go | Haskell | 
                Html | Java | Javascript | Latex | LUA | Make | OCaml | ObjectiveC | 
                Perl | PHP | Python | Ruby | Scala | Tcl | Sh | Verilog | Vim
                    deriving (Read, Show, Eq, Ord, Bounded)


data FileType = Name String | Ext String
                    deriving (Show,Eq,Ord)


type LangMapType    = Map.Map Lang [FileType]
type LangRevMapType = Map.Map FileType Lang


langMap :: LangMapType
langMap = Map.fromList [
            (Awk,       [Ext "awk", Ext "mawk", Ext "gawk"]),
            (C,         [Ext "c", Ext "C"]),
            (Cpp,       [Ext "cpp", Ext "CPP", Ext "cxx", Ext "cc", Ext "cp", Ext "tcc", Ext "h", Ext "H", Ext "hpp", Ext "HPP", Ext "hxx", Ext "hh", Ext "hp"]),
            (Csharp,    [Ext "cs", Ext "CS"]),
            (Css,       [Ext "css"]),
            (CMake,     [Name "CMakeLists.txt", Ext "cmake"]),
            (D,         [Ext "d", Ext "D"]),
            (Erlang,    [Ext "erl", Ext "ERL",Ext  "hrl", Ext "HRL"]),
            (Fsharp,    [Ext "fs", Ext "fsx"]),
            (Go,        [Ext "go"]),
            (Haskell,   [Ext "hs", Ext "lhs"]),
            (Html,      [Ext "htm", Ext "html"]),
            (Java,      [Ext "java"]),
            (Javascript,[Ext "js"]),
            (Latex ,    [Ext "latex", Ext "tex"]),
            (LUA ,      [Ext "lua"]),
            (Make,      [Name "Makefile", Name "makefile", Name "GNUmakefile", Ext "mk", Ext  "mak"]),
            (OCaml ,    [Ext "ml", Ext "mli"]),
            (ObjectiveC,[Ext "m", Ext "mi"]),
            (Perl,      [Ext "pl", Ext "pm", Ext "plx", Ext "perl"]),
            (PHP,       [Ext "php", Ext "php3", Ext "php4", Ext "php5",Ext "phtml"]),
            (Python,    [Ext "py", Ext "pyx", Ext "pxd", Ext "pxi", Ext "scons"]),
            (Ruby,      [Ext "rb", Ext "ruby"]),
            (Scala,     [Ext "scala"]),
            (Tcl,       [Ext "tcl", Ext "tk"]),
            (Sh,        [Ext "sh", Ext "bash", Ext "csh", Ext "tcsh", Ext "ksh", Ext "zsh"]),
            (Verilog,   [Ext "v", Ext "vh", Ext "sv"]),
            (Vim,       [Ext "vim"])
          ]


langRevMap :: LangRevMapType
langRevMap = Map.fromList $ concatMap (\(lang, xs) -> map (\x -> (x,lang)) xs ) $ Map.toList langMap 

-- utility functions 

lookupLang :: String -> Maybe Lang
lookupLang f = Map.lookup (Ext (let name = takeExtension f in case name of ('.':xs) -> xs; _ -> name )) langRevMap <|> Map.lookup (Name f) langRevMap 


dumpLangMap :: LangMapType -> IO ()
dumpLangMap m = forM_ (Map.toList m) $ \(lang, ex) ->
                putStrLn $ show lang ++ replicate (16 - length (show lang)) ' ' ++ "-> " ++ show ex


dumpLangRevMap :: LangRevMapType -> IO ()
dumpLangRevMap m = forM_ (Map.toList m) $ \(ext, lang) -> 
                    putStrLn $ show ext ++ replicate (16 - length (show ext)) ' ' ++ "-> " ++ show lang
