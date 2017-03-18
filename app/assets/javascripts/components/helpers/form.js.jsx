class InputField extends React.Component {
  render() {
    let {className, ...props} = this.props
    className = ['form-field', className].join(' ')
    return (
      <input type='text' className={className} {...props}/>
      )
  }
}

class FormGroupInput extends React.Component {
  render() {
    let {title, ...props} = this.props
    return (
      <div className='form-group'>
        <label htmlFor={props.id}>{title}</label>
        <InputField {...props} />
      </div>
      )
  }
}

class FormGroup extends React.Component {
  render() {
    return (
      <div className='form-group'>
        <label>{this.props.title}</label>
        {this.props.children}
      </div>
      )
  }
}

class SubmitButton extends React.Component {
  render() {
    return (
      <input type='submit' className='btn btn-default' {...this.props} />
      )
  }
}

class TextareaField extends React.Component {
  render() {
    return (
      <textarea className='form-field' {...this.props}></textarea>
      )
  }
}

class HiddenField extends React.Component {
  render() {
    return (
      <input type='hidden' {...this.props} />
      )
  }
}

class SelectTag extends React.Component {
  componentDidMount() {
    let $el = $(this.el)
    $el.select2({
      tags: true,
      tokenSeparators: [','],
      width: '100%'
    });
  }

  renderOptions(item) {
    return ( <option key={item}>{item}</option> )
  }

  render() {
    let {className, ...props} = this.props;
    return (
      <select
        ref={(el) => this.el = el}
        defaultValue={this.props.values}
        {...props}>
        {$.map(this.props.values, this.renderOptions)}
      </select>
      )
  }
}

class SelectField extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: 0
    }
    this.handleChange = this.handleChange.bind(this);
  }
  componentDidMount() {
    let $el = $(this.el)
    $el.select2({width: '100%'})
      .on('change', this.handleChange);
  }

  handleChange(e) {
    this.setState({selected: e.target.value})
  }

  renderOptions(item, index) {
    return <option key={item}>{item}</option>
  }

  render() {
    let {options, prompt, ...props} = this.props;
    options = [prompt, ...options];
    return (
      <select
        ref={(el) => this.el = el}
        value={this.state.selected}
        {...props}>
        {$.map(options, this.renderOptions)}
      </select>
      )
  }
}

SelectTag.defaultProps = {
  values: []
}

SelectField.defaultProps = {
  prompt: "---"
}