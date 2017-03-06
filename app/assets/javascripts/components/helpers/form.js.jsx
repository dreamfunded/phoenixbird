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
      <input type='submit' {...this.props} />
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
    className = ['js-select2-tags', className].join(' ');
    return (
      <select
        ref={(el) => this.el = el}
        defaultValue={this.props.values}
        className={className} {...props}>
        {$.map(this.props.values, this.renderOptions)}
      </select>
      )
  }
}

SelectTag.defaultProps = {
  values: []
}