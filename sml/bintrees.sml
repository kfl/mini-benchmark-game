(* The Computer Language Benchmarks Game
 * https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 *
 * Contributed by Troestler Christophe
 * Modified by Fabrice Le Fessant
 * Adapted to SML by Martin Elsman
 *)

datatype tree = Empty | Node of tree * tree

fun make d =
  if d = 0 then Node(Empty, Empty)
  else let val d = d - 1 in Node(make d, make d) end

val rec check = fn Empty => 0 | Node(l, r) => 1 + check l + check r

val def_depth = 10
val min_depth = 4
val max_depth =
    let val n =
            case CommandLine.arguments() of
                nil => def_depth
              | x::_ => case Int.fromString x of SOME i => i
                                               | NONE => def_depth
    in Int.max (min_depth + 2, n)
    end
val stretch_depth = max_depth + 1

val () =
  let val c = check (make stretch_depth)
  in print ("stretch tree of depth " ^ Int.toString stretch_depth ^
            "\t check: " ^ Int.toString c ^ "\n")
  end

val long_lived_tree = make max_depth

fun for (s,e) f =
    if s > e then ()
    else (f s ; for (s+1,e) f)

fun loop_depths d =
    for (0,((max_depth - d) div 2 + 1) - 1)
        (fn i =>
            let val d = d + i * 2
                val niter = Word.toInt(Word.<<(0w1, Word.fromInt(max_depth - d + min_depth)))
                val c = ref 0
            in for (1,niter)
                   (fn i => c := !c + check(make d))
             ; print (Int.toString niter ^ "\t trees of depth " ^
                      Int.toString i ^ "\t check: " ^
                      Int.toString (!c) ^ "\n")
            end)

val () =
    ( loop_depths min_depth
    ; print ("long lived tree of depth " ^ Int.toString max_depth ^
             "\t check: " ^ Int.toString (check long_lived_tree) ^ "\n")
    )
