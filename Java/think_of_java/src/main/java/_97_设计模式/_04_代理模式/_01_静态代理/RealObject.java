package _97_设计模式._04_代理模式._01_静态代理;

/**
 * create by lwj on 2020/3/20
 */
public class RealObject implements BuyInterface {

    @Override
    public void buy() {
        System.out.println("买房");
    }
}
