# SPDX-License-Identifier: BSD-3-Clause
# Copyright (C) 2025-2026 Taylor (Wakana Kisarazu)
import std/[strformat, strutils]


when not defined(debug):
    {.push optimization:speed, checks:off, warnings:off.}


const 
    RESET   = "\e[0m"
    BOLD    = "\e[1m"
    DIM     = "\e[2m"
    RED     = "\e[31m"
    GREEN   = "\e[32m"
    YELLOW  = "\e[33m"
    BLUE    = "\e[34m"
    CYAN    = "\e[36m"
    SEP     = "------------------------------"


#[ In order of severity:
    fail, warn,
    info, okay, debug only ]#

type ConsoleLogLevel = enum
    F, W, I, O, D

#[ Not to be used externally, the templates 
   are for use by other parts of the Forge
   package application ]#
proc consoleLog(msg: string, lvl: ConsoleLogLevel) =
    var prefix = ""
    var fileno = stdout 

    case lvl
    of F: prefix = fmt("{BOLD}{RED} FAIL :: "); fileno = stderr
    of W: prefix = fmt("{BOLD}{YELLOW} WARN :: ")
    of I: prefix = fmt("{BOLD}{BLUE} INFO :: ")
    of O: prefix = fmt("{BOLD}{GREEN} OKAY :: ")
    of D: prefix = fmt("{BOLD}{CYAN} DEBG %% ")

    fileno.writeLine(fmt("{prefix} {msg} {RESET}"))
    fileno.flushFile()

template consoleFail*[T](msg: T) =
    var m = msg

    when T is string:
        m = msg
    else:
        m = $msg

    consoleLog(m, F)

template consoleWarn*[T](msg: T) =
    var m = msg

    when T is string:
        m = msg
    else:
        m = $msg

    consoleLog(m, W)

template consoleInfo*[T](msg: T) =
    var m = msg

    when T is string:
        m = msg
    else:
        m = $msg

    consoleLog(m, I)

template consoleOkay*[T](msg: T) =
    var m = msg

    when T is string:
        m = msg
    else:
        m = $msg

    consoleLog(m, O)

template consoleDebug*[T](msg: T) =
    var m = msg

    when T is string:
        m = msg
    else:
        m = $msg

    when defined(debug):
        consoleLog(m, D)
    else:
        discard

#[ You know, templates expand
   at compile-time, perfect
   for exposing APIs ]#
proc consoleDimSep*() =
    echo(fmt("{DIM}{SEP}{RESET}"))
