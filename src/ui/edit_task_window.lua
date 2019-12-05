-- UI
local ui = require "tek.ui"

-- Controllers
local get_task = require "src.controller.get_task"
local edit_task = require "src.controller.edit_task"
local delete_task = require "src.controller.delete_task"

-- Utils
local date = require "date.date"

-- Constats
local row_space = 5


return {
    set_task_to_edit = function(self, task_id)
        local task = get_task(task_id)
        local start_time = date(task.start_time)
        local end_time = date(task.end_time)

        self:getById("edit_start_date"):setValue("Text", string.format(
            "%02d/%02d/%04d",
            start_time:getday(),
            start_time:getmonth(),
            start_time:getyear()
        ))
        self:getById("edit_start_time"):setValue("Text", string.format(
            "%02d:%02d",
            start_time:gethours(),
            start_time:getminutes()
        ))
        self:getById("edit_end_date"):setValue("Text", string.format(
            "%02d/%02d/%04d",
            end_time:getday(),
            end_time:getmonth(),
            end_time:getyear()
        ))

        self:getById("edit_end_time"):setValue("Text",  string.format(
            "%02d:%02d",
            end_time:gethours(),
            end_time:getminutes()
        ))
        self:getById("edit_description"):setValue("Text", task.description)
        self:getById("edit_project"):setValue("Text", task.project)
        --self:getById("edit_in_progress"):setValue("Text", "")

        self:getById("delete_task_btn"):setValue("onPress", function(self)
            delete_task(task_id)
            self:getById("edit_task_window"):setValue(
                "Status", "hide"
            )
        end)

        self:getById("save_task_btn"):setValue("onPress", function(self)
            -- Read new values from edit fields
            local new_start_date = self:getById("edit_start_date"):getText()
            local new_start_time = self:getById("edit_start_time"):getText()
            local new_start = date(
                string.format("%sT%s:00", new_start_date, new_start_time)
            )

            local new_end_date = self:getById("edit_end_date"):getText()
            local new_end_time = self:getById("edit_end_time"):getText()
            local new_end = date(
                string.format("%sT%s:00", new_end_date, new_end_time)
            )

            local new_description = self:getById("edit_description"):getText()
            local new_project = self:getById("edit_project"):getText()

            -- Trigger field update when a change is detected
            if new_start ~= start_time then
                edit_task(task.id, "start_time", new_start)
            end

            if new_end ~= end_time then
                edit_task(task.id, "end_time", new_end)
            end

            if new_description ~= task.description then
                edit_task(task.id, "description", new_description)
            end

            if new_project ~= task.project then
                edit_task(task.id, "project", new_project)
            end

            self:getById("edit_task_window"):setValue(
                "Status", "hide"
            )
        end)
    end,
    init = function()
        return ui.Window:new {
            Title = "Edit Task",
            Id = "edit_task_window",
            Style = "margin: 15;",
            Status = "hide",
            Orientation = "vertical",
            Width = 400,
            Height = 300,
            Children = {
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Style = "margin-bottom: "..row_space..";",
                    Children = {
                        ui.Text:new{
                            Style = "text-align: left;",
                            Width = 100,
                            Text = "Time:",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_start_date",
                            Width = 76,
                            Text = "27/11/2019"
                        },
                        ui.Area:new{
                            Width = 2,
                            Height = "auto"
                        },
                        ui.Input:new{
                            Id = "edit_start_time",
                            Width = 40,
                            Text = "21:14"
                        },
                        ui.Text:new{
                            Width = 20,
                            Text = "To",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_end_time",
                            Width = 40,
                            Text = "23:14"
                        },
                        ui.Area:new{
                            Width = 2,
                            Height = "auto"
                        },
                        ui.Input:new{
                            Id = "edit_end_date",
                            Width = 76,
                            Text = "27/11/2019"
                        },
                        ui.Area:new{
                            Width = 5,
                            Height = "auto"
                        },
                        ui.CheckMark:new{
                            Id = "edit_in_progress",
                            Text = "In Progress",
                            Selected = false,
                            onSelect = function(self)
                            end
                        }
                    }
                },
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Style = "margin-bottom: "..row_space..";",
                    Children = {
                        ui.Text:new{
                            Style = "text-align: left;",
                            Width = 100,
                            Text = "Description:",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_description",
                            Width = "fill"
                        }
                    }
                },
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Style = "margin-bottom: "..(row_space * 2)..";",
                    Children = {
                        ui.Text:new{
                            Style = "text-align: left;",
                            Width = 100,
                            Text = "Project:",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_project",
                            Width = "fill"
                        }
                    }
                },
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Children = {
                        ui.Button:new{
                            Id = "delete_task_btn",
                            Width = 80,
                            Text = "Delete"
                        },
                        ui.Area:new{
                            Width = "free",
                            Height = "auto"
                        },
                        ui.Button:new{
                            Width = 80,
                            Text = "Cancel",
                            onPress = function(self)
                                self:getById("edit_task_window"):setValue(
                                    "Status", "hide"
                                )
                            end
                        },
                        ui.Button:new{
                            Id = "save_task_btn",
                            Width = 80,
                            Text = "Save"
                        }
                    }
                }
            }
        }
    end
}