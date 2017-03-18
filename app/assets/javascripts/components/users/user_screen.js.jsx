class UserScreen extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.state = {
      user: props.user
    }
  }

  handleSubmit(e) {
    let $form = $(e.target);
    let newState = $.extend({}, this.state.user, $.deparam($form.serialize()));
    this.setState({user: newState});
  }

  render() {
    let userData = this.state.user;
    return (
      <FluidContainer>
        <GridRow>
          <div className="col-3">
            <UserSide user={userData}/>
          </div>
          <div className="col-9">
            <UserInfo user={userData} onSubmit={this.handleSubmit}/>
          </div>
        </GridRow>
      </FluidContainer>
      )
  }
}

class UserSide extends React.Component {
  render() {
    let userData = this.props.user;
    return (
      <div>
        <a href='#'>
          <img
            className='width-100'
            src={userData.image_url} />
        </a>
        <div>
          <h2>{userData.first_name}</h2>
        </div>
        <VerifiedInfoPanel data={userData.verifications.user}/>
        <ConnectedAccountsPanel data={userData.verifications.connected_accounts}/>
      </div>
      )
  }
}

class VerifiedInfoPanel extends React.Component {
  render() {
    return (
      <Panel title="Verifications">
        <VerificationList data={this.props.data}/>
      </Panel>
      )
  }
}

class VerificationList extends React.Component {
  render() {
    let data = this.props.data;
    return (
      <ul className='list-group verifications'>
        <li>Email address<VerifiedMark check={data.email}/></li>
        <li>Phone number<VerifiedMark check={data.phone}/></li>
      </ul>
      )
  }
}

class VerifiedMark extends React.Component {
  render() {
    let {check} = this.props;
    let stateClasses = {
      'grey-color': !check,
      'green-color': check,
    }
    let className = 'fa fa-check-circle-o ' + $.classNames(stateClasses);
    return (
      <span className='pull-right'>
        <i className={className}></i>
      </span>
      )
  }
}

class ConnectedAccountsPanel extends React.Component {
  render() {
    return (
      <Panel title="Connected Accounts">
        <ConnectedAccountList data={this.props.data}/>
      </Panel>
      )
  }
}

class ConnectedAccountList extends React.Component {
  render() {
    let data = this.props.data;
    return (
      <ul className='list-group verifications'>
        <li>Google<VerifiedMark check={data.google}/></li>
        <li>Facebook<VerifiedMark check={data.facebook}/></li>
        <li>Twitter<VerifiedMark check={data.twitter}/></li>
        <li>LinkedIn<VerifiedMark check={data.linkedin}/></li>
        <li>AngelList<VerifiedMark check={data.angellist}/></li>
      </ul>
      )
  }
}

class UserInfo extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
  }

  render() {
    let userData = this.props.user;

    return (
      <div>
        <UserBasicInfo onSubmit={this.handleSubmit} user={userData}/>
        <GridRow>
          <div className='col-12'>
            <UserInfoSection title='Activity'>
              Hello
            </UserInfoSection>
            <UserFormContainer user={userData} childView='UserAboutSectionContainer' />
            <UserInvestmentSection user={userData} />
            <WorkExperienceInfoSection user={userData} />
            <UserInfoSection title='Connections/Mutual Connections'>
              Hello
            </UserInfoSection>
            <UserInfoSection title='People Also Viewed'>
              Hello
            </UserInfoSection>
          </div>
        </GridRow>
      </div>
      )
  }
}

class WorkExperienceInfoSection extends React.Component {
  render() {
    let userData = this.props.user;
    let workExperiences = userData.work_experiences;
    let educations = userData.educations;

    return (
      <UserInfoSection id='experience-education-section' title='Work Experience & Education'>
        <WorkExperienceContainer work_experiences={workExperiences} />
        <EducationContainer educations={educations} />
      </UserInfoSection>
      )
  }
}

class EducationContainer extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
    this.state = {
      educations: props.educations,
    }
  }

  handleSubmit(e) {
    e.preventDefault();
    var _this = this;
    let $form = $(e.target);
    let serializedData = $.deparam($form.serialize());
    var education = serializedData.school_attributes;
    education.new_item = true
    var educations = this.state.educations;
    this.setState({educations: [education, ...educations]});

    $.ajax({
      url: '/api/users/educations',
      method: 'POST',
      data: {education: serializedData},
      success: function(response) {
        $.extend(education, response);
        educations = [education, ...educations];
        _this.setState({educations: educations});
      }
      });
  }

  handleDelete(e) {

  }

  render() {
    let educations = this.state.educations;

    return (
      <div>
        <h4>Education</h4>
        <QuickAddEducationForm onSubmit={this.handleSubmit} />
        <EducationList
          onDelete={this.handleDelete}
          educations={educations}
          />
      </div>
      )
  }
}

class WorkExperienceContainer extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
    this.state = {
      work_experiences: props.work_experiences,
    }
  }

  handleSubmit(e) {
    e.preventDefault();
    var _this = this;
    let $form = $(e.target);
    let serializedData = $.deparam($form.serialize());
    var workExperience = serializedData.community_company_attributes
    workExperience.new_item = true
    var workExperiences = this.state.work_experiences;
    this.setState({work_experiences: [workExperience, ...workExperiences]});

    $.ajax({
      url: '/api/users/work_experiences',
      method: 'POST',
      data: {work_experience: serializedData},
      success: function(response) {
        $.extend(workExperience, response);
        workExperiences = [workExperience, ...workExperiences];
        _this.setState({work_experiences: workExperiences});
      }
      });
  }

  handleDelete(e) {
    var $target = $(e.target);
    var targetId = $target.data('id');
    let workExperiences = this.state.work_experiences.filter(function(item) {
      return item.id != targetId
      });
    this.setState({work_experiences: workExperiences});

    $.ajax({
      url: '/api/users/destroy_work_experience',
      method: 'DELETE',
      data: {id: targetId}
      })
  }

  render() {
    let workExperiences = this.state.work_experiences;

    return (
      <div>
        <h4>Experience</h4>
        <QuickAddExperienceForm onSubmit={this.handleSubmit}/>
        <WorkExperienceList
          onDelete={this.handleDelete}
          workExperiences={workExperiences}/>
      </div>
      )
  }
}

class EducationList extends React.Component {
  constructor(props) {
    super(props);
    this.handleDelete = this.handleDelete.bind(this);
    this.renderItem = this.renderItem.bind(this);
  }

  handleDelete(e) {
    this.props.onDelete(e);
  }

  renderItem(item, index) {
    return (
      <EditableEducationItem
        onDelete={this.handleDelete}
        education={item}
        new_item={item.new_item}
        key={index}/>
      )
  }

  render() {
    let educations = this.props.educations;
    return (
      <div>
        {$.map(educations, this.renderItem)}
      </div>
      )
  }
}

class EditableEducationItem extends React.Component {
  render() {
    let education = this.props.education;
    return (
      (this.props.is_editing)
        ? "Hello"
        : <EducationItem education={education} />
      )
  }
}
EditableEducationItem = App.concerns.Editable(EditableEducationItem)

class EducationItem extends React.Component {
  render() {
    let education = this.props.education;
    return (
      <div className='media with-margin-bottom'>
        <div className='media-left'>
          <div className='image-container'>
            <a href='#'>
              <i className='fa fa-graduation-cap media-object'></i>
            </a>
          </div>
        </div>
        <div className='media-body'>
          {education.school_name || education.name}
          <h4>{education.major}</h4>
        </div>
      </div>
      )
  }
}

class WorkExperienceList extends React.Component {
  constructor(props) {
    super(props);
    this.handleDelete = this.handleDelete.bind(this);
    this.renderItem = this.renderItem.bind(this);
  }

  handleDelete(e) {
    this.props.onDelete(e);
  }

  renderItem(item, index) {
    return (
      <EditableWorkExperienceItem
        onDelete={this.handleDelete}
        work_experience={item}
        new_item={item.new_item}
        key={index}/>
      )
  }

  render() {
    let workExperiences = this.props.workExperiences;
    return (
      <div>
        {$.map(workExperiences, this.renderItem)}
      </div>
      )
  }
}

class EditableWorkExperienceItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      work_experience: props.work_experience
      }
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
  }

  handleDelete(e) {
    this.props.onDelete(e);
  }

  handleSubmit(e) {
    let $form = $(e.target);
    let formData = $.deparam($form.serialize())
    $.ajax({
      url: '/api/users/update_profile',
      method: 'PUT',
      data: {user: formData},
      })
    let workExperience = $.extend(
      {},
      this.state.work_experience,
      formData.work_experiences_attributes);
    this.setState({work_experience: workExperience});
    this.props.cancelEdit(e);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      work_experience: nextProps.work_experience
      });
  }

  render() {
    let work_experience = this.state.work_experience;
    return (
      (this.props.is_editing)
        ? <WorkExperienceEditForm
            onSubmit={this.handleSubmit}
            onCancel={this.props.cancelEdit}
            onDelete={this.handleDelete}
            work_experience={work_experience} />
        : <WorkExperienceItem
            onEdit={this.props.toggleEdit}
            work_experience={work_experience} />
      )
  }
}
EditableWorkExperienceItem = App.concerns.Editable(EditableWorkExperienceItem)

class WorkExperienceEditForm extends React.Component {
  constructor(props) {
    super(props);
    this.handleCancel = this.handleCancel.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
  }

  handleCancel(e) {
    this.props.onCancel(e);
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
  }

  handleDelete(e) {
    e.preventDefault(e);
    if (confirm('Are you sure you want to delete this entry?')) {
      this.props.onDelete(e)
    };
  }

  render() {
    let work_experience = this.props.work_experience;
    return (
      <form onSubmit={this.handleSubmit}>
        <div className='media with-margin-bottom'>
          <div className='media-left'>
            <a href='#'>
              <img className='media-object'/>
            </a>
          </div>
          <div className='media-body'>
            <div className='clearfix margin-button-10'>
              <div>
                <span>{work_experience.company_name || work_experience.name}</span>
                <div className='pull-right action-buttons'>
                  <SubmitButton
                    className='btn btn-primary btn-small action-button-item'
                    value='Save'/>
                  <button
                    onClick={this.handleDelete}
                    className='btn btn-default btn-small action-button-item'
                    data-id={work_experience.id}>
                    Delete
                  </button>
                  <a
                    onClick={this.handleCancel}
                    href='#'
                    className='font-smaller grey-color action-button-item'>Cancel</a>
                </div>
              </div>
            </div>
            <div className='well no-border'>
              <HiddenField name='work_experiences_attributes[id]' defaultValue={work_experience.id}/>
              <div className='form-group'>
                <label>Title</label>
                <InputField defaultValue={work_experience.title} name='work_experiences_attributes[title]'/>
              </div>
              <div className='form-group'>
                <label>Description</label>
                <TextareaField defaultValue={work_experience.description} name='work_experiences_attributes[description]'/>
              </div>
            </div>
          </div>
        </div>
      </form>
      )
  }
}

class WorkExperienceItem extends React.Component {
  constructor(props) {
    super(props);
    this.handleEdit = this.handleEdit.bind(this);
  }

  handleEdit(e) {
    this.props.onEdit(e);
  }

  render() {
    let {work_experience, index} = this.props;
    return (
      <div
        className='media with-margin-bottom'>
        <div className='context-actions'>
          <span
            onClick={this.handleEdit}
            className='context-action-item'><i className='fa fa-pencil'></i></span>
        </div>
        <div className='media-left'>
          <div className='image-container'>
            <a href='#'>
              <i className='fa fa-building-o media-object'></i>
            </a>
          </div>
        </div>
        <div className='media-body'>
          {work_experience.company_name || work_experience.name}
          <h4>{work_experience.title}</h4>
        </div>
      </div>
      )
  }
}

class QuickAddExperienceForm extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.state = { value: '' };
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
    this.setState({value: ''});
  }

  handleChange(e) {
    this.setState({value: e.target.value});
  }

  render() {
    let value = this.state.value;

    return (
      <Well>
        <form onSubmit={this.handleSubmit} className='form-horizontal'>
          <GridRow className='no-margin'>
            <div className='col-3'>
              <label className='vmiddle'>ADD EXPERIENCE</label>
            </div>
            <div className='col-9'>
                <div className='form-inline'>
                  <div className='form-group no-margin'>
                    <InputField
                      value={value}
                      onChange={this.handleChange}
                      placeholder="Company"
                      name='community_company_attributes[name]'/>
                  </div>
                  <div className='form-group no-margin'>
                    <SubmitButton value='Add'/>
                  </div>
                </div>
            </div>
          </GridRow>
        </form>
      </Well>
      )
  }
}

class QuickAddEducationForm extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.state = { value: '' };
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
    this.setState({value: ''});
  }

  handleChange(e) {
    this.setState({value: e.target.value});
  }

  render() {
    let value = this.state.value;
    return (
      <Well>
        <form onSubmit={this.handleSubmit} className='form-horizontal'>
          <GridRow className='no-margin'>
            <div className='col-3'>
              <label className='vmiddle'>ADD EDUCATION</label>
            </div>
            <div className='col-9'>
              <div className='form-inline'>
                <div className='form-group no-margin'>
                  <InputField
                    value={value}
                    onChange={this.handleChange}
                    name='school_attributes[name]'
                    placeholder='School name' />
                </div>
                <div className='form-group no-margin m-width-100p'>
                  <YearRangeSelect name="graduation_year" />
                </div>
                <div className='form-group no-margin'>
                  <SubmitButton value='Add' />
                </div>
              </div>
            </div>
          </GridRow>
        </form>
      </Well>
      )
  }
}

class UserFormContainer extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleFileUpload = this.handleFileUpload.bind(this);
    this.state = {
      user: props.user
    }
    this.files = [];
  }

  handleFileUpload(e) {
    this.files = e.target.files;
  }

  handleSubmit(e) {
    e.preventDefault();
    let $form = $(e.target);
    let formData = new FormData();
    let serializedData = $.deparam($form.serialize());
    let userData = {user: serializedData}
    let imageData = this.files[0]; // this assumes we upload only one file in this form;

    $.each(serializedData, function(k, v) {
      formData.append(`user[${k}]`, v);
    });
    if (imageData) { formData.append('user[image]', imageData) };

    $.ajax({
      url: "/api/users/update_profile",
      method: "PUT",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    this.setState(userData);
    this.props.onSubmit && this.props.onSubmit(e);
  }

  render() {
    let userData = this.state.user;
    let ChildView = window[this.props.childView];
    return (
      <ChildView
        {...this.props}
        user={userData}
        onSubmit={this.handleSubmit}
        onFileUpload={this.handleFileUpload}/>
      )
  }
}

class UserAboutSectionContainer extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
  }

  render() {
    let userData = this.props.user;
    let aboutSection = <UserAboutShowSection user={userData} />
    let aboutEditSection = <UserAboutEditSection user={userData} />

    return (
      <UserEditableSection
        onSubmit={this.handleSubmit}
        title='About'
        showView={aboutSection}
        editView={aboutEditSection} />
      )
  }
}

class UserInvestmentSection extends React.Component {
  render() {
    let userData = this.props.user;
    let {investments} = userData;

    return (
      <UserInfoSection title='Investment'>
        <div className='clearfix flex-grid centered'>
          {$.map(investments, this.renderInvestmentItem)}
        </div>
      </UserInfoSection>
      )
  }

  renderInvestmentItem(item) {
    let {company} = item;

    return (
      <div key={item.id} className='col-3'>
        <div className='user-investment'>
          <div className='image-container'>
            <a href='#'>
              <img src={company.image_url}/>
            </a>
          </div>
          <h4 className='centered'>
            {company.name}
          </h4>
          <div className='grey-color'>
            {item.date_invested}
          </div>
        </div>
      </div>
      )
  }
}

class UserAboutShowSection extends React.Component {
  render() {
    let userData = this.props.user;
    let skills = userData.skills.join(', ');
    return (
      <div>
        <UserAboutPanelSection title='Bio' content={userData.bio} />
        <UserAboutPanelSection title='Aspirations' content={userData.aspirations} />
        <UserAboutPanelSection title='Achievements' content={userData.achievements} />
        <UserAboutPanelSection title='Skills' content={skills}/>
        <UserAboutPanelSection title="What I'm Looking For" content={userData.looking_for} />
      </div>
      )
  }
}

class UserAboutEditSection extends React.Component {
  render() {
    let userData = this.props.user;
    return (
      <div>
        <UserAboutPanelSection
          className='form-group'
          title='Bio'
          content={ <TextareaField name="bio" defaultValue={userData.bio}/> } />
        <UserAboutPanelSection
          className='form-group'
          title='Aspirations'
          content={ <TextareaField name="aspirations" defaultValue={userData.aspirations}/> } />
        <UserAboutPanelSection
          className='form-group'
          title='Achievements'
          content={ <TextareaField name="achievements" defaultValue={userData.achievements}/> } />
        <UserAboutPanelSection
          className='form-group'
          title='Skills'
          content={ <SelectTag name="skills" multiple={true} values={userData.skills} /> }/>
        <UserAboutPanelSection
          className='form-group'
          title="What I'm Looking For"
          content={ <TextareaField name="looking_for" defaultValue={userData.looking_for}/> } />
      </div>
      )
  }
}

class UserAboutPanelSection extends React.Component {
  render() {
    let className = this.props.className;
    return (
      <GridRow className={className}>
        <div className='col-3 uppercase grey-color'>
          {this.props.title}
        </div>
        <div className='col-9'>
          {this.props.content}
        </div>
      </GridRow>
      )
  }
}

class UserEditableSection extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isEditing: false
    }
    this.toggleEdit = this.toggleEdit.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
    this.toggleEdit(e);
  }

  toggleEdit(e) {
    e.preventDefault();
    this.setState({isEditing: !this.state.isEditing})
  }

  render() {
    let {title, showView, editView} = this.props;
    let _showView = <UserShowSection onClick={this.toggleEdit} content={showView}/>
    let _editView =
      <UserEditSection
        onSubmit={this.handleSubmit}
        onClick={this.toggleEdit}
        content={editView}/>
    return (
      <UserInfoSection title={title}>
        {this.state.isEditing
          ? _editView
          : _showView}
      </UserInfoSection>
      )
  }
}

class UserShowSection extends React.Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(e) {
    this.props.onClick(e);
  }

  render() {
    return (
      <div>
        <p className='clearfix margin-top-none'>
          <a
            onClick={this.handleClick}
            href='#'
            className='font-smaller uppercase pull-right'>Edit</a>
        </p>
        {this.props.content}
      </div>
      )
  }
}

class UserEditSection extends React.Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
  }

  handleClick(e) {
    this.props.onClick(e);
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div className="clearfix">
          <p className='pull-right margin-top-none'>
            <a
              onClick={this.handleClick} href='#'
              className='font-smaller uppercase grey-color'>Cancel </a>
            <SubmitButton value="SAVE" />
          </p>
        </div>
        <div>
          {this.props.content}
        </div>
      </form>
      )
  }
}

class UserBasicInfo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isEditing: false
    }
    this.toggleEdit = this.toggleEdit.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
    this.toggleEdit(e);
  }

  toggleEdit(e) {
    e.preventDefault();
    this.setState({isEditing: !this.state.isEditing});
  }

  render() {
    let userData = this.props.user;
    return (
      <div>
        <div className='row'>
          <h4 className='pull-right no-margin'>
            <a href='#' onClick={this.toggleEdit} className='uppercase'>Edit Profile</a>
          </h4>
        </div>
        {this.state.isEditing
          && <UserFormContainer
               onSubmit={this.handleSubmit}
               user={userData}
               childView='UserBasicInfoForm' />}
      </div>
      )
  }
}

class UserBasicInfoForm extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleFileUpload = this.handleFileUpload.bind(this);
  }

  handleSubmit(e) {
    this.props.onSubmit(e);
  }

  handleFileUpload(e) {
    this.props.onFileUpload(e);
  }

  render() {
    let userData = this.props.user;
    return (
      <form onSubmit={this.handleSubmit}>
        <div className='row'>
          <div className='pull-right margin-top-none'>
            <SubmitButton value="SAVE" />
          </div>
        </div>
        <GridRow>
          <div className='col-6'>
            <h4>Basic Info</h4>
            <FormGroupInput
              title='First name'
              id='user_first_name'
              name='first_name'
              defaultValue={userData.first_name}/>
            <FormGroupInput
              title='Last name'
              id='user_last_name'
              name='last_name'
              defaultValue={userData.last_name}/>
            <FormGroupInput
              title='Username'
              id='user_login'
              name='login'
              defaultValue={userData.login}/>
            <FormGroupInput
              title='Profile photo'
              id='user_image'
              name='image'
              type='file'
              onChange={this.handleFileUpload}/>
            <h4>Links</h4>
            <FormGroup title='Websites'>
              <InputField
                name='websites[]'
                placeholder='https://...'
                defaultValue={userData.websites[0]}/>
              <InputField
                name='websites[]'
                placeholder='https://...'
                defaultValue={userData.websites[1]}/>
              <InputField
                name='websites[]'
                placeholder='https://...'
                defaultValue={userData.websites[2]}/>
            </FormGroup>
          </div>
          <div className='col-6'>
            <h4>Verifications</h4>
            <FormGroupInput
              title="Email address"
              defaultValue={userData.email} />
            <FormGroupInput
              title="Phone number"
              defaultValue={userData.phone} />
            <OAuthConnector name='Google' provider='google_oauth2'/>
            <OAuthConnector name='Facebook' provider='facebook'/>
            <OAuthConnector name='LinkedIn' provider='linkedin'/>
          </div>
        </GridRow>
      </form>
      )
  }
}

class OAuthConnector extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: props.name,
      disabled: false
    }
    this.path = props.path || `/auth/${props.provider}`;
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(e) {
    var _this = this;
    e.preventDefault();
    this.setState({name: 'Connecting...', disabled: true});

    $.oauthpopup({
      path: _this.path,
      callback: function() {
        $.ajax({
          url: '/api/users/check_identity',
          method: 'GET',
          data: {provider: _this.props.provider},
          complete: function() {
            _this.setState({name: _this.props.name, disabled: false});
          }
        })
      }
    });
  }

  render() {
    let {provider} = this.props;
    let {name} = this.state;
    let className = `${provider}-link`; ;
    className += {true: ' link--disabled'}[this.state.disabled] || '';
    return (
      <a
        href={this.path}
        className={className}
        onClick={this.handleClick}>
        <span>{name}</span></a>
      )
  }
}

class UserInfoSection extends React.Component {
  render() {
    return (
      <div id={this.props.id} className='panel panel-minimal'>
        <div className='panel-heading'>
          <h4>{this.props.title}</h4>
        </div>
        <div className='panel-body'>
          {this.props.children}
        </div>
      </div>
      )
  }
}