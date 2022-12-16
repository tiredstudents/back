# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    case user.post
    when 'project owner'
      project_owner_abilities
    when 'project manager'
      project_manager_abilities
    when 'hr'
      hr_abilities
    when 'manager'
      manager_abilities
    when 'employee'
      employee_abilities
    end
  end

  def project_owner_abilities
    can :manage, :all
  end

  def project_manager_abilities
    can :all, Grade
    can :create, Grade
    can :index, Project
    can :resources, Project
    can :show, Project
    can :update, Project
    can :free_resource, Project
    can :all, Skill
    can :create, Skill
    can :index, User
    can :show, User
    can :projects, User
    can :managed_projects, User
    can :update, User
    can :index, Vacancy
    can :show, Vacancy
    can :create, Vacancy
    can :update, Vacancy
    can :close, Vacancy
  end

  def hr_abilities
    can :index, Candidate
    can :vacancies, Candidate
    can :show, Candidate
    can :create, Candidate
    can :update, Candidate
    can :destroy, Candidate
    can :all, Grade
    can :create, Grade
    can :index, Project
    can :show, Project
    can :all, Skill
    can :create, Skill
    can :index, User
    can :show, User
    can :projects, User
    can :managed_vacancies, User
    can :create, User
    can :update, User
    can :fire, User
    can :index, Vacancy
    can :show, Vacancy
    can :assign_for_hr, Vacancy
    can :unassign, Vacancy
    can :create, Vacancy
    can :update, Vacancy
    can :close, Vacancy
    can :complete, Vacancy
  end

  def manager_abilities
    can :all, Grade
    can :create, Grade
    can :index, Project
    can :resources, Project
    can :show, Project
    can :free_resource, Project
    can :all, Skill
    can :create, Skill
    can :managed_projects, User
    can :show, User
    can :projects, User
    can :index, Vacancy
    can :show, Vacancy
    can :complete, Vacancy
  end

  def employee_abilities
    can :show, User
    can :projects, User
    can :all, Grade
    can :all, Skill
  end
end
