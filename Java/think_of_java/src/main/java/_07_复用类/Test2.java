package _07_复用类;

/**
 * create by lwj on 2020/3/12
 */
public class Test2 {
    public static void main(String[] args) {
        Zi zi = new Zi();
    }
}

class Fu {
    Fu(int i) {
        System.out.println("fu " + i);
    }

    void print(int i) {
        System.out.println("fu " + i);
    }
}

class Zi extends Fu {
    Zi() {
        this(1);
        System.out.println("zi " + 3);
        super.print(4);
    }

    Zi(int i) {
        super(1);
        this.print(2);
    }

    @Override
    void print(int i) {
        System.out.println("zi " + i);
    }
}
