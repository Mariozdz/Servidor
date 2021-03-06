package Model;



import Datos.ScheduleDao;
import Logic.Schedule;
import org.json.JSONArray;

import java.util.List;

public class ScheduleModel {

    private static ScheduleModel instance = null;
    private ScheduleDao entity;

    private ScheduleModel() {
        this.entity = new ScheduleDao();
    }

    public ScheduleDao getEntity() {
        return entity;
    }

    public static ScheduleModel getInstance() {
        if (instance == null)
            instance = new ScheduleModel();
        return instance;
    }

    public void Insert(Schedule u) throws Throwable {
        entity.insert(u);
    }
    public void Update(Schedule u) throws Throwable {
        entity.update(u);
    }
    public void Delete(int id) throws Throwable {
        entity.delete(id);
    }
    public Schedule Get(int id) throws Throwable {
        return entity.get(id);
    }
    public List<Schedule> search() throws Throwable {
        return entity.search();
    }
    public JSONArray getCompleteSchedule() throws Throwable {
        return entity.getCompleteSchedule();
    }

    public JSONArray searchWithHour() throws Throwable
    {
        return entity.searchWithHour();
    }

}
