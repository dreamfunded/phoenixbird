class UserScreen extends React.Component {
  render() {
    let userData = this.props.user;
    return (
      <FluidContainer>
        <GridRow>
          <div className="col-3">
            <UserSide user={userData}/>
          </div>
          <div className="col-9">
            <UserInfo user={userData}/>
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
          <img className='width-100' src={userData.image_url} />
        </a>
        <div>
          <h2>{userData.first_name}</h2>
        </div>
      </div>
      )
  }
}

class UserInfo extends React.Component {
  render() {
    let userData = this.props.user;

    return (
      <div>
        <UserBasicInfo />
        <UserInfoSection title='Activity'>
          Hello
        </UserInfoSection>
        <UserAboutSectionContainer user={userData}/>
        <UserInvestmentSection user={userData}/>
        <UserInfoSection title='Work Experience & Education'>
          Hello
        </UserInfoSection>
        <UserInfoSection title='Connections/Mutual Connections'>
          Hello
        </UserInfoSection>
      </div>
      )
  }
}

class UserAboutSectionContainer extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.state = {
      user: props.user
    }
  }

  handleSubmit(e) {
    e.preventDefault();
    let $form = $(e.target);
    let formData = $.deparam($form.serialize());
    let userData = {user: formData}
    $.ajax({
      url: "/api/users/update_profile",
      method: "PUT",
      data: userData
    })
    this.setState(userData);
  }

  render() {
    let userData = this.state.user;
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
    return (
      <div>
        <UserAboutPanelSection title='Bio' content={userData.bio} />
        <UserAboutPanelSection title='Aspirations' content={userData.aspirations} />
        <UserAboutPanelSection title='Achievements' content={userData.achievements} />
        <UserAboutPanelSection title='Skills' />
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
          content={ <SelectTag multiple={true} /> }/>
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
  }

  toggleEdit(e) {
    e.preventDefault();
    this.setState({isEditing: !this.state.isEditing});
  }

  render() {
    return (
      <div>
        <div className='clearfix'>
          <h4 className='pull-right'>
            <a href='#' onClick={this.toggleEdit} className='uppercase'>Edit Profile</a>
          </h4>
        </div>
        {this.state.isEditing && <UserBasicInfoForm />}
      </div>
      )
  }
}

class UserBasicInfoForm extends React.Component {
  render() {
    return (
      <form>
        <div className='clearfix'>
          <p className='pull-right margin-top-none'>
            <SubmitButton value="SAVE"/>
          </p>
        </div>
        <GridRow>
          <div className='col-6'>
            <h4>Basic Info</h4>
            <FormGroupInput title='First name' id='user_first_name' name='first_name'/>
            <FormGroupInput title='Last name' id='user_last_name' name='last_name'/>
            <FormGroupInput title='Username' id='user_login' name='login'/>
          </div>
          <div className='col-6'>
            <h4>Verifications</h4>
          </div>
        </GridRow>
      </form>
      )
  }
}

class UserInfoSection extends React.Component {
  render() {
    return (
      <div className='panel panel-minimal'>
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