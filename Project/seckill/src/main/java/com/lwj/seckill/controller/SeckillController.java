package com.lwj.seckill.controller;

import com.lwj.seckill.dto.Exposer;
import com.lwj.seckill.dto.SeckillExecution;
import com.lwj.seckill.dto.SeckillResult;
import com.lwj.seckill.enums.SeckillStatEnum;
import com.lwj.seckill.exception.RepeatKillException;
import com.lwj.seckill.exception.SeckillCloseException;
import com.lwj.seckill.pojo.Seckill;
import com.lwj.seckill.service.SeckillService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * create by lwj on 2019/11/27
 */
@Controller
@RequestMapping("seckill")
@Slf4j
public class SeckillController {
    @Autowired
    private SeckillService seckillService;

    @RequestMapping(value = "/list", method = RequestMethod.GET)

    public String list(Model model) {
        List<Seckill> seckillList = seckillService.getSeckillList();
        model.addAttribute("list", seckillList);
        return "list";
    }

    @RequestMapping(value = "/{seckillId}/detail", method = RequestMethod.GET)
    public String deatil(@PathVariable("seckillId") Long seckillId, HttpServletRequest req, HttpServletResponse res, Model model) throws IOException, ServletException {
        if (seckillId == null) {
            res.sendRedirect("/seckill/list");
        }
        Seckill seckill = seckillService.getById(seckillId);
        if (seckill == null) {
            req.getRequestDispatcher("/seckill/list").forward(req, res);
        }
        model.addAttribute("seckill", seckill);
        return "detail";
    }

    @RequestMapping(value = "/{seckillId}/exposer")
    @ResponseBody
    public SeckillResult<Exposer> exposer(@PathVariable(value = "seckillId") Long seckillId) {
        SeckillResult<Exposer> res;
        try {
            Exposer exposer = seckillService.exportSeckillUrl(seckillId);
            res = new SeckillResult<>(true, exposer);
        } catch (Exception e) {
            log.error(e.getMessage());
            res = new SeckillResult<>(false, e.getMessage());
        }
        return res;
    }

    @RequestMapping(value = "/{seckillId}/{md5}/execution", method = RequestMethod.POST)
    @ResponseBody
    public SeckillResult<SeckillExecution> execute(@PathVariable("seckillId") Long seckillId, @PathVariable("md5") String md5,
                                                   @CookieValue(value = "userPhone", required = false) Long userPhone) {

        if (userPhone == null) {
            return new SeckillResult<>(false, "未注册");
        }
        SeckillResult<SeckillExecution> res;
        try {
            //通过调用存储过程直接在数据库执行秒杀事务
            SeckillExecution seckillExecution = seckillService.executeSeckillProcedure(seckillId, userPhone, md5);
            //由spring控制事务来执行秒杀操作
//            SeckillExecution seckillExecution = seckillService.executeSeckill(seckillId, userPhone, md5);
            res = new SeckillResult(true, seckillExecution);
        } catch (RepeatKillException e) {
            SeckillExecution seckillExecution = new SeckillExecution(seckillId, SeckillStatEnum.REPEAT_KILL);
            res = new SeckillResult<>(false, seckillExecution);
        } catch (SeckillCloseException e) {
            SeckillExecution seckillExecution = new SeckillExecution(seckillId, SeckillStatEnum.END);
            res = new SeckillResult<>(false, seckillExecution);
        } catch (Exception e) {
            log.error(e.getMessage());
            SeckillExecution seckillExecution = new SeckillExecution(seckillId, SeckillStatEnum.INNER_ERROR);
            res = new SeckillResult<>(false, seckillExecution);
        }
        return res;
    }

    @RequestMapping(value = "/time/now", method = RequestMethod.GET)
    @ResponseBody
    public SeckillResult<Long> time() {
        Date date = new Date();
        return new SeckillResult<>(true, date.getTime());
    }
}
