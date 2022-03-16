use typed_arena::Arena;

struct Tree<'a> {
    l: TreeRef<'a>,
    r: TreeRef<'a>,
}
type TreeRef<'a> = Option<&'a Tree<'a>>;

fn check(t: &TreeRef) -> i64 {
    match t {
        None => 0,
        Some(boxed) => {
            let Tree{ref l, ref r} = **boxed;
            1 + check(l) + check(r)
        }
    }
}

fn create<'a>(arena: &'a Arena<Tree<'a>>, depth: i32) -> TreeRef<'a> {
    Some(if depth > 0 {
        arena.alloc(Tree {
            l: create(arena, depth - 1),
            r: create(arena, depth - 1),
        })
    } else {
        arena.alloc(Tree { l: None, r: None })
    })
}

const MIN_DEPTH: i32 = 4;

fn main() {
    let n = std::env::args_os()
        .nth(1)
        .and_then(|s| s.into_string().ok())
        .and_then(|n| n.parse().ok())
        .unwrap_or(10);

    let max_depth = if MIN_DEPTH + 2 > n { MIN_DEPTH + 2 } else { n };
    {
        let depth = max_depth + 1;
        let arena = Arena::new();
        let tree = create(&arena, max_depth + 1);

        println!("stretch tree of depth {}\t check: {}", depth, check(&tree));
    }

    let long_lived_arena = Arena::new();
    let long_lived_tree = create(&long_lived_arena, max_depth);

    for d in (MIN_DEPTH..max_depth + 1).step_by(2) {
        let iterations = 1 << ((max_depth - d + MIN_DEPTH) as u32);
        let mut chk = 0;
        for _i in 0..iterations {
            let arena = Arena::new();
            let a = create(&arena, d);
            chk += check(&a);
        }
        println!("{}\t trees of depth {}\t check: {}", iterations, d, chk)
    }

    println!(
        "long lived tree of depth {}\t check: {}",
        max_depth,
        check(&long_lived_tree)
    );
}
