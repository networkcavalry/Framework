package _97_设计模式._02_适配器模式;

/**
 * create by lwj on 2020/3/16
 */
public class MultiplyAdapter1 extends Multiply implements Operator  {
    @Override
    public int process(int i1, int i2) {
        return multiply(i1,i2);
    }
}
