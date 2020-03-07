package com.lwj._02_factory_pattern._02_abstractFactory;

/**
 * create by lwj on 2019/1/12
 */
public interface CarFactory {
    Engine createEnine();
    Seat createSeat();
    Tyre createTyre();
}

